[参考](https://www.jianshu.com/p/695d9e0e8af4)
[参考](https://www.howtoing.com/how-to-query-prometheus-on-ubuntu-14-04-part-2/)

二. 查询语言
https://prometheus.io/docs/prometheus/latest/querying/basics/

1. 基础
Prometheus 提供了一种 函数表达式语言 , 这让用户可以实时 select and aggregate time series data.
表达式的结果可以作为graph展示, 也可以在Prometheus's expression browser中以扁平的数据查看, 或通过 HTTP API 被外部系统消费(consumed).
( 其实都是通过 HTTP API 获取数据 , 包括 Prometheus's expression browser )

表达式语言的数据类型:
在 Prometheus 的表达式语言中,一个表达式或子表达式(sub-expression)可以评估为4种类型之一:
( 这些数据类型 可以在 web页里的console中 查看其值来加深理解 )

(1) Instant vector(即时向量): 一组时间序列(time series),这些时间序列包含一个单独的sample(样本数据),共享相同的时间戳.
例如 http_requests_total 或 http_requests_total{job="prometheus",group="canary"} 或者 {job="prometheus",group="canary"} 或者 http_requests_total{environment=~"staging|testing|development",method!="GET"}
label的值可以匹配正则表达式:

(a) = 等号 表示 精确匹配
(b) != 表示 不等于提供的字符串
(c) =~ 表示 正则匹配
(d) !~ 表示 正则不匹配
正则表达式不能匹配空字符串(必须至少有一个label不匹配空字符串),
例如
{job=~".*"} 这是不合法的.
{job=~".+"} 这是合法的.
{job=~".*",method="get"} 这也是合法的.

正则表达式也可以用于匹配 metric name ,使用内部的  __name__ label
{__name__=~"^job:.*"}

(2) Range vector(范围向量): 一组时间序列(time series),这些时间序列包含一段时间范围内的数据点. 例如: 表示时间的单位有 s m h d w y
http_requests_total{job="prometheus"}[5m]

(3) Scalar(标量): 一个简单的浮点数字值

(4) String(字符串): 一个简单的字符串值. 当前未使用

根据使用情况(例如画图或者展示表达式的输出时)，只有某些表达式的结果是合法的.
例如 返回 Instant vector 类型的表达式 是可以画图的唯一类型

字符串字面值可以使用 单引号、双引号和反引号``括起来.

PromQL 遵循 Go语言 的escaping rules. 在单引号和双引号中使用 \ 作为escape符号,其后面可以跟 \a \b \f \n \r \t \v \\ . 或者使用八进制(\nnn)或十六进制(\xnn,\unnnn,\Unnnnnnnn).

使用反引号``括起来的字符串没有转义.
但和Go不同的是, Prometheus不会丢弃backticks中的换行符.
例如: `these are not unescaped: \n ' " \t`

浮点数字面值例子: -2.43

操作符:
Prometheus 支持许多 binary and aggregation 操作符,后面再讲(什么是 binary and aggregation 操作符 ? 二元和聚合的操作符)

函数:
Prometheus 支持多种操作数据的函数. 后面再讲

Gotchas(got you?)(陷阱?)
Interpolation and staleness(插值和陈旧):
当运行查询时，时间戳是独立于实际的当前时间序列数据 选择的采样数据.
这主要是为了支持聚合(sum,avg等等)场景,这种场景下多个被聚合的时间序列在时间上并不完全对齐. 因为它们彼此独立, Prometheus 需要在那些时间戳上指定一个值,指定的这个值一般就是简单的使用在这个时间戳之前的最新的样本值.

但是如果5分钟(默认值)之内没有样本值, 那这个时间点上就没有值. 也就是说这意味着这个时间序列在这个时间点从graph上"消失"了.

注意: 这种处理方式将来可能会改变.
查看 https://github.com/prometheus/prometheus/issues/398 和 https://github.com/prometheus/prometheus/issues/581

避免缓慢的查询和过载
如果查询需要对大量数据进行操作, 对它进行绘图可能会 超时或超载.
因此，当对未知数据构造查询时, 首先要在 Prometheus's expression browser 中调试 ,直到结果集合看起来合理了(最多数百个时间序列,而不是上千个).
只有当您充分筛选或汇总数据时，才能切换到图形模式。
如果该表达式仍然花费太长时间来绘制ad-hoc,可以通过 recording rule 对其 pre-record .

这和 PromQL 有关,使用一个bare metric name selector(例如 api_http_requests_total)可能会选择到数以千计的不同labels的time series.
还要记住，在多个时间序列上聚合的表达式将在服务器上产生负载，即使输出只是少量的时间序列.
这类似于在关系数据库中对列的所有值求和的速度很慢，即使输出值只是一个数字.

2. 操作符
PromQL 支持基本的逻辑和算术运算符。
对于两个即时向量之间的操作， matching behavior 可以修改
(
can be modified. 什么意思? 看了后面会理解,但是这里先说两句
操作符应用于两个即时向量(只能应用于即时向量)时,一般来说总是先进行匹配,而后才进行操作符运算,匹配规则是尝试针对左侧向量中的每个元素 在右侧向量中查找对应的匹配元素.
匹配不到的元素将不作为结果的一部分,但是这种匹配规则可以通过增加一些关键字被修改,后面有详细说明
)

二元算术运算符
+ - * / % ^(power)
可以应用于 标量/标量 、 向量/标量 、 向量/向量 中.

二元算术运算符 应用于 即时向量/标量 时
运算符将应用于向量中的每个样本值.
结果向量的metric name被丢弃.
例如:

employee_age_bucket_bucket{le="30"}  +2 
返回的是

{instance="10.0.86.71:8080",job="prometheus",le="30"} 3002
可以看到结果中的metric name被丢弃了.

二元算术运算符 应用于 应用于 即时向量/即时向量 时
运算符将应用于左侧向量中的元素及其在右侧向量中的匹配到的元素.
运算结果被传播到结果向量中，并且度量名称被丢弃.
那些在右侧向量中没有匹配条目的条目 不是结果的一部分。
例如:

employee_age_bucket_bucket{le=~"20|30|40"} + employee_age_bucket_bucket{le=~"30|40|50"}
返回的是

{instance="10.0.86.71:8080",job="prometheus",le="30"} 6000
{instance="10.0.86.71:8080",job="prometheus",le="40"} 8000
可以看到 左侧向量中的元素中只有与右侧匹配的元素参与了计算,并且结果中的metric name被丢弃了.

比较运算符
== != > >= < <=
可以应用于 标量/标量 、 向量/标量 、 向量/向量 中.

默认情况下, 这些运算符用于filter.
但是如果在运算符后提供了 bool修饰符 该行为会发生改变,此时它们会返回 0或1 而不是 filtering

比较运算符 应用于 标量/标量 时
必须提供 bool修饰符 , 并且该运算符会产生一个 0或1 的标量值.
例如:

3 > 2
# 报错 "comparisons between scalars must use BOOL modifier"

3 > bool 2 
# 返回 scalar 1

1 > bool 2 
# 返回 scalar 0 
比较运算符 应用于 即时向量/标量 时
运算符将应用于向量中的每个样本值,并且 运算结果为 0 的元素会被丢弃.
如果提供了 bool修饰符 , 向量中的值会变为 0或1.
例如:

employee_age_bucket_bucket > 1 
# 结果是 value <=1 的time series被丢了

employee_age_bucket_bucket > bool 1 
# 结果是 time series 的值变为了0或1
比较运算符 应用于 即时向量/即时向量 时
运算符的默认行为仍然是过滤.
向量中那些 在另一侧没有匹配元素的元素 以及 匹配到的元素间的运算结果为 0 的都会被丢弃, 同时左侧向量中的其他的元素被生成到结果向量中(元素的值不变).
如果提供了 bool修饰符 , 那些没有匹配到的元素 该丢弃还是丢弃, 而运算结果为0的元素不会被丢弃,只是值都变成了 0或者1.
例如:

employee_age_bucket_bucket{le=~"20|30|40"} >=  employee_age_bucket_bucket{le=~"30|40|50"}
返回的是

employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="30"} 3000
employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="40"} 4000
又例如:

employee_age_bucket_bucket{le=~"20|30|40"} > bool employee_age_bucket_bucket{le=~"30|40|50"}
返回的是

employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="30"} 0
employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="40"} 0
Logical/set binary operators( 逻辑/集合 二元操作符 )
这些操作符只应用于 即时向量/即时向量 中: and or unless

vector1 and vector2 的结果是
vector1 中的labels在vector2中存在的元素被保留,其他的被丢弃.
例如:

employee_age_bucket_bucket{le=~"20|30|40"} and employee_age_bucket_bucket{le=~"30|40|50"}
返回的

employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="30"} 3000
employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="40"} 4000
vector1 or vector2 的结果是
vector1中的所有元素和值,以及vector2中没有在vector1中匹配到的元素.

vector1 unless vector2 的结果是
和 and 正相反, 返回的是 vector1 中的labels在vector2中存在的元素被丢弃,其他的被保留.
例如:

employee_age_bucket_bucket{le=~"20|30|40"} unless employee_age_bucket_bucket{le=~"30|40|50"}
返回的

employee_age_bucket_bucket{instance="10.0.86.71:8080",job="prometheus",le="20"} 1000
Vector matching(向量匹配)行为
在两个向量之间的运算(好像不包括 and or unless 这种集合对集合的运算,它们属于 many-to-many?)总是尝试针对左侧向量中的每个元素 在右侧向量中查找对应的匹配元素.
这种匹配行为 有2种基础类型 :

(1) one-to-one :
匹配唯一的完全相同的label标签组和label对应的值都相同的元素
意思就是 左侧向量 中的元素的标签 在 右侧向量 中最多只有一个元素的标签与之对应,同时反之亦然.
这是 vector1 <operator> vector2 的默认行为.

关键字 ignoring 允许你在匹配时忽略某些标签,
关键字 on 允许将匹配的标签组减少为提供的列表,

语法格式为:

<vector expr> <bin-op> ignoring|on(<label list>) <vector expr>
例如:

employee_age_bucket_bucket{le=~"20|30|40"} > bool ignoring(job,instance) employee_age_bucket_bucket{le=~"30|40|50"}
返回的是 ( 注意1: 和之前 不加 ignoring 返回内容的区别是 labels 不一样了) ( 注意2: 如果是 ignoring(le), 那么匹配行为就不是 one-to-one 了,会报错 )

employee_age_bucket_bucket{le="30"} 0
employee_age_bucket_bucket{le="40"} 0
又例如

employee_age_bucket_bucket{le=~"20|30|40"} > bool on(le) employee_age_bucket_bucket{le=~"30|40|50"}
返回的是 (只有 labels 没有 metric name,为什么没有 metric name? 因为 on list 中没有 name , 如果加上则 metric name 就会出现)

{le="30"}  0
{le="40"}  0
(2) many-to-one 和 one-to-many
这是指 某一侧的向量中的元素的可以与 另一侧的向量中的多个元素相匹配(元素匹配的意思是指它们的labels相同).
此时必须使用修饰符 group_left (左侧的多个元素对应右侧的单个元素时) 或 group_right (左侧的单个元素对应右侧的多个元素时) 来显式地表达这一请求.
语法格式为:

<vector expr> <bin-op> ignoring|on(<label list>) group_left|group_right(<label list>) <vector expr>
group修饰符中提供的 label list 包含了 "one"-side 中的 额外的 labels,这些labels会包含在结果的标签组中.
同时 on或ignoring 提供的 label list 和 group修饰符提供的 labels 不能重复,结果向量中的每个时间序列都必须是唯一可识别的.

grouping修饰符只能用于数学和比较运算符,不能用于 and,unless,or 运算符.

例如

employee_age_bucket_bucket{le=~"30|40"} / ignoring(le) group_left employee_age_bucket_count
返回 ( 没有 metric name )

{instance="10.0.86.71:8080",job="prometheus",le="30"} 0.28
{instance="10.0.86.71:8080",job="prometheus",le="40"} 0.76
聚合运算符:
Prometheus 支持一些内建的聚合运算符,这些运算符可以用于汇总单个的即时向量的元素, 生成一个由被聚合的值组成的新向量.
这些聚合运算符 包括:

sum min max avg count
count_values(按元素的值分组,分别计算具有相同的值的元素的数量)
stddev (计算标准偏差(standard deviation))
stdvar (计算标准方差(standard variance ))
bottomk/topk (最小/大的k个元素)
quantile (计算 0-1 之间的百分比数量的样本的最大值)
这些操作符可以用于聚合 all label 维度,也可以聚合 预留的 distinct labels 维度,通过使用 without 或 or 子句.

其标准语法是

<aggr-op>([parameter,] <vector expression>) [without|by (<label list>)] [keep_common]
parameter 只有部分运算符用到( count_values, quantile, topk and bottomk ).
without 列出的labels会从结果向量中移除.
by 列出的labels会在结果向量中保留,其他labels则会被移除
keep_common 子句允许在结果向量中保持那些额外的labels(必须是唯一的),
使用without时不能使用 keep_common , 这应该很容易理解.
例如:
sum(http_requests_total) 会返回所有的样本值的和. 相当于group null
sum(http_requests_total) without (instance) 会按照除了instance label之外,以其他相同labels分组的各分组中的样本值的和

运算符优先级
算数运算符(^幂操作符优先级最高) > 比较运算符 > 逻辑运算符

一般来说相同优先级的运算符是从左到右运算的,

但是 幂运算操作符有点特殊
例子: 2^3^2 等价于 2^(3^2)

总之, 自己写的时候多用 () , 看别人写的时候不确定顺序就再查一下

3. 函数
3.1 数学函数等
abs(v instant-vector) 返回向量中所有样本值的绝对值

ceil(v instant-vector) 返回向量中所有样本值的向上取整数

floor(v instant-vector) 返回向量中所有样本值的向下取整数

round(v instant-vector, to_nearest=1 scalar) 返回向量中所有样本值的最接近的整数,
to_nearest是可选的,默认为1,表示样本返回的是最接近1的整数倍的值, 可以指定任意的值(也可以是小数),表示样本返回的是最接近它的整数倍的值

exp(v instant-vector) 计算指数值. 即 e的value次方.
value值够大时会返回 +Inf.
特殊情况为:
Exp(+Inf)=+Inf
Exp(NaN)=NaN

ln(v instant-vector) 计算ln(value)值.
value值够大时会返回 +Inf.
特殊情况为:
ln(0)=-Inf
ln(x<0)=NaN
ln(NaN)=NaN

log2,log10 类似于ln,

sqrt

scalar(v instant-vector) 的参数是一个单元素的即时向量,它返回其唯一的time series的值作为一个标量. 如果参数不合法则返回 NaN

vector(s scalar) 返回一个空labels的、值为s的向量

sort(v instant-vector) 对向量按元素的值进行升序排序

sort_desc(v instant-vector) 对向量按元素的值进行降序排序

count_scalar(v instant-vector) 返回的是一个标量值,
和 count() 运算符不一样,count()返回的是 一个向量.

day_of_month(v=vector(time()) instant-vector) 返回向量中每个元素值代表的时间的day_of_month,
如果不提供参数则时间当前时间

day_of_month,days_in_month,day_of_week(0-6),hour,minute,month,year

time() 返回从1970-1-1起至今的秒数. 注意它一般不表示实际的当前时间,而是表达式被evaluated时的时间

histogram_quantile(φ float, b instant-vector) 从 bucket 类型的向量中 计算 φ (0 ≤ φ ≤ 1) 百分比的样本的最大值.
所谓 bucket 类型就是 labels 中必须要有 le 这个label 来表示 不同bucket区间 的样本数量.
没有 le 标签的 time series 会被忽略.
可以使用 rate() 函数来指定 计算的时间窗口. (关于rate函数的描述见后面)
例如:
histogram_quantile(0.5,rate(employee_age_bucket_bucket[10m]))
返回
{instance="10.0.86.71:8080",job="prometheus"} 35.714285714285715
这表示 最近10分钟之内 50%的样本 最大值为 35.71...
这个计算结果是 每组labels 组合一个time series , 如果要聚合的话, 使用 sum() 聚合操作符.
如下所示:
histogram_quantile(0.5,sum(rate(employee_age_bucket_bucket[10m])) by (job,le))
如果要聚合所有的label,则如下:
histogram_quantile(0.5,sum(rate(employee_age_bucket_bucket[10m])) by (le))

注意1: histogram_quantile这个函数是根据假定每个区间内的样本分布是线性分布来计算结果值的(也就是说它的结果未必准确). 最高的bucket必须是 le="+Inf" (否则就返回NaN).
注意2: 如果 b 含有少于 2 个 buckets , 那么会返回 NaN , 如果 φ<0 会返回 -Inf . 如果 φ > 1 会返回 +Inf

absent(v instant-vector) 如果参数向量有任何的元素就返回一个空的向量,否则返回一个单元素的向量,其值为1,其labels为你指定的labels.
也就是说对于一个给定的metric name 和 label组合 不存在 time series 时,你可以得到一个 单元素的向量.
例如: absent(non_exists_metric) 返回 {} 1 , 其 labels 为空
例如: absent(anyMetric{anyLabel:"anyValue") 返回 {anyLabel:"anyValue"} 1 , 其 labels 为给定的labels组合
例如: absent(employee_age_bucket_bucket{job="myjob",instance=~".*"}) 返回 {job="myjob"} 1 , 正在匹配的instance不作为返回labels中的一部分

clamp_max(v instant-vector, max scalar) clamp(钳住)即时向量中的每个元素的值,不让它们的最大值超越指定的最大值.

clamp_min(v instant-vector, min scalar) clamp(钳住)即时向量中的每个元素的值,不让它们的最小值超越指定的最小值.

drop_common_labels(instant-vector) 会丢弃一些labels,这些被丢弃的labels是所有的time series中都存在且labels值都相同的label

label_replace(v instant-vector, dst_label string, replacement string, src_label string, regex string) 对于每个time series, 它会使用正则表达式匹配源标签的值,如果匹配到则增加一个目标标签,且其值由replacement表示.
例如:  label_replace(up{job="api-server",service="a:c"}, "foo", "$1", "service", "(.*):.*") 会返回一个向量,每个time series都会增加一个 foo 标签,其值为 a .

3.2 范围向量函数
changes(v range-vector) 的参数是一个范围向量, 他返回一个即时向量
labels不变,值是 元素的值发生变化的次数.
例如: changes(requests_total[2d])
返回 {instance="xx",job="yy",method="zz",requestpath="xx"} 3703

delta(v range-vector) 的参数是一个范围向量,返回一个即时向量
它计算每个time series中的第一个值和最后一个值的差别,
由于这个值 is extrapolated to (被外推到) 指定的整个时间范围,所以可能你会得到一个非整数值,即使样本值都是整数.
这个函数一般只用在 gauge 类型的time series 上.

idelta(v range-vector) 的参数是一个范围向量, 返回一个即时向量
它计算最新的2个样本值之间的差别.
这个函数一般只用在 gauge 类型的time series 上.

deriv(v range-vector) 的参数是一个范围向量,返回一个即时向量.
它计算每个time series的每秒的导数(derivative),它使用简单的现行回归计算这个导数(using simple linear regression).
这个函数一般只用在 gauge 类型的time series 上

holt_winters(v range-vector, sf scalar, tf scalar) 的参数是一个范围向量
它根据 范围向量 中的范围 产生一个平滑的值.
平滑因子sf越小, 对旧数据的重视程度越高.
趋势因子tf越大, 对数据的趋势的考虑就越多.
sf和tf都必须在0和1之间.
这个函数一般只用在 gauge 类型的time series 上 (没看懂)

increase(v range-vector) 的参数是一个范围向量.
它计算指定范围内的增长值, 它会在单调性发生变化时(如由于目标重启引起的计数器复位)自动中断.
由于这个值 is extrapolated to (被外推到) 指定的整个时间范围,所以可能你会得到一个非整数值,即使样本值都是整数.
这个函数一般只用在 counter 类型的time series 上.

rate(v range-vector) 的参数是一个范围向量.
它计算每秒的平均增长值.
它会在单调性发生变化时(如由于目标重启引起的计数器复位)自动中断.
这个函数一般只用在 counter 类型的time series 上.
一般用于 alert .

irate(v range-vector) 的参数是一个范围向量.
它计算每秒的平均增长值, 它基于的是最新的2个数据点,而不是第一个和最后一个值.

predict_linear(v range-vector, t scalar) 根据线性分布预测n秒后的值,基于给定的范围向量.

resets(v range-vector) 的参数是一个范围向量.
对于每个 time series , 它都返回一个 counter resets的次数,
两个连续样本之间的值的降低被认为是一次 reset.

<aggregation>_over_time(v range-vector)
一些聚合运算符有这种用法,它们会聚合每个time series的range,并返回一个即时向量:

avg_over_time(range-vector): 计算指定时间段内所有点的平均值
min_over_time, max_over_time, sum_over_time, count_over_time, stddev_over_time, stdvar_over_time
4. HTTP API
当前文档的 HTTP API 都位于 /api/v1 下
API 的响应都是 JSON 格式的.
成功的 API 响应的返回码都是 2xx
失败的 API 响应的返回码: 400(表示参数缺失或不正确) 422(表示表达式不能被执行) 503(表示服务超时或中断)
其他的 非2xx 的返回码 可能表示 没有请求到 API endpoint 返回的错误
返回的JSON格式为:

{
    "status":"success" | "error",
    "data":<data>,
    // 如果发生错误时
    "errorType":"<string>",
    "error":"<string>"
}
输入的时间戳应该使用 RFC3339格式或unix时间戳格式(即秒数).
输出的时间戳总是按照Unix时间戳格式
输入参数 <series_selector> 需要 urlencoded,它就是: http_requests_total or http_requests_total{method=~"^GET|POST$"}
<duration> 使用 [0-9]+[smhdwy]
4.1 表达式查询
即时向量查询
GET /api/v1/query

参数1: query
query=<string>: Prometheus expression query string

参数2: time
time=<rfc3339 | unix_timestamp> : Evaluation timestamp

参数3: timeout
timeout=<duration>: Evaluation timeout. Optional. Defaults to and is capped by the value of the -query.timeout flag.

范围向量查询
GET /api/v1/query_range
参数:query,start,end,step,timeout

......

作者：坚持到底v2
链接：https://www.jianshu.com/p/695d9e0e8af4
來源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。