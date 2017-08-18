访问地址：
http://172.16.18.5:31600/epg_server/mango_tv

参考ui：
http://172.16.18.5:32000/apigw/

[root@apigw-129285491-5x3kr /]# redis-cli --raw keys "*"
1502692613

root@apigw-129285491-5x3kr /]# redis-cli LRANGE  $(redis-cli --raw keys "*") 0 -1 
1) "desktop|getHomepage|192.168.169.248|GET|200|603|493|0.007|0.007|2017-08-14T14:39:49+08:00"
2) "desktop|getHomepageCfg|192.168.169.248|GET|200|581|17882|0.013|0.013|2017-08-14T14:39:49+08:00"
3) "weather|getWeather|192.168.169.248|GET|200|559|457|0.004|0.004|2017-08-14T14:39:49+08:00"
4) "mssServiceId|mss_routlist|192.168.36.174|GET|200|542|9461|0.029|0.029|2017-08-14T14:39:49+08:00"



1. 客户端 获取redis的信息
2. 封装到agetn中
3. server 获取agent中的数据
4. grafana展示



使用cnpm，以后用cnpm速度快
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"


1. json --> import "github.com/tidwall/gjson"
2. redis --> import "github.com/go-redis/redis"

写之前再看下这个：
http://yunlzheng.github.io/2017/07/07/prometheus-exporter-example-go/


除了基本度量类型，仪表盘，计数器，摘要，直方图和未知类型，
普罗米修斯数据模型的一个非常重要的部分是沿着维度划分样本，称为标签，导致度量向量。
基本类型有GaugeVec，CounterVec，SummaryVec，HistogramVec和UntypedVec。
选择结构，即GaugeOpts，CounterOpts，SummaryOpts，HistogramOpts或UntypedOpts。



keys *，列出所有的数据,找出最小的   或者获取当前时间戳，减一秒获取


参考资料：
[Prometheus 之 Hello world
](https://bugs.ltd/article/1501476325406?p=1&m=0)
[给程序添加Prometheus监控](https://mzh.io/%E7%BB%99%E7%A8%8B%E5%BA%8F%E6%B7%BB%E5%8A%A0Prometheus%E7%9B%91%E6%8E%A7)
[用 Golang 實作 Prometheus：服務效能測量監控系統](https://yami.io/golang-prometheus/)
[使用Prometheus监控服务器性能](http://cjting.me/linux/use-prometheus-to-monitor-server/)

+ 加标签
方法一：
hdFailures.With(prometheus.Labels{"裝置":"/dev/sda"}).Inc()
方法二：
rpcDurations.WithLabelValues("exponential").Observe(v)


Observe 是添加数据的


这个要多看
http://cjting.me/linux/use-prometheus-to-monitor-server/

http://172.16.18.5:4194/metrics



prometheus.BuildFQName(*metricsNamespace, "upstream", metricName)

prometheus.BuildFQName 方法，是用来把里面的三个参数使用-连接起来，作为名字使用
return strings.Join([]string{namespace, subsystem, name}, "_")




可以自己实现Exporter结构,这个结构要附带Describe 和 Collect



# Server Requests
apigw_server_requests{code="1xx",host="test.domain.com"} 0


apigw_http_requests_total

# 请求次数
apigw_server_requests{service="desktop"} 100

#状态码
apigw_server_http_code{service="desktop",uri="getHomepage",remote_ip="192.168.169.248",http_method="GET"} 200

#状态码---使用label counter
apigw_http_requests_total{service="desktop",uri="getHomepage",remote_ip="192.168.169.248",http_method="GET",http_code="200"} 1

#接收字节数 summery
apigw_server_bytes_recv{service="desktop",uri="getHomepage",remote_ip="192.168.169.248",http_method="GET",http_code="200"} 603

#发送字节数 summery
apigw_server_bytes_sent{service="desktop",uri="getHomepage",remote_ip="192.168.169.248",http_method="GET",http_code="200"} 493

#请求响应时间 summery
apigw_server_request_time{service="desktop",uri="getHomepage",remote_ip="192.168.169.248",http_method="GET",http_code="200"} 0.013

#回源时间 summery
apigw_server_upstream_response_time{service="desktop",uri="getHomepage",remote_ip="192.168.169.248",http_method="GET",http_code="200"} 0.013



0. 首先查询service有哪些标签
label_values(service)


1. service 标签可选
All
desktop
weather


2. 平均5分钟  http_code 对应的数量
sum(irate(apigw_http_requests_total{role=~"$role",status=~"$status",host!="127.0.0.1"}[5m])) by (status)

sum(rate(apigw_http_request_duration_seconds_sum{role="$role",host!="127.0.0.1"}[1m])) / sum(rate(apigw_http_request_duration_seconds_count{role="$role",host!="127.0.0.1"}[1m]))





Counter

Counter用于累计值，例如记录请求次数、任务完成数、错误发生次数。一直增加，不会减少。重启进程后，会被重置。

例如：http_response_total{method=”GET”,endpoint=”/api/tracks”} 100，10秒后抓取http_response_total{method=”GET”,endpoint=”/api/tracks”} 100。

Gauge

Gauge常规数值，例如 温度变化、内存使用变化。可变大，可变小。重启进程后，会被重置。

例如： memory_usage_bytes{host=”master-01″} 100 < 抓取值、memory_usage_bytes{host=”master-01″} 30、memory_usage_bytes{host=”master-01″} 50、memory_usage_bytes{host=”master-01″} 80 < 抓取值。

Histogram

Histogram（直方图）可以理解为柱状图的意思，常用于跟踪事件发生的规模，例如：请求耗时、响应大小。它特别之处是可以对记录的内容进行分组，提供count和sum全部值的功能。

例如：{小于10=5次，小于20=1次，小于30=2次}，count=7次，sum=7次的求和值。

Summary

Summary和Histogram十分相似，常用于跟踪事件发生的规模，例如：请求耗时、响应大小。同样提供 count 和 sum 全部值的功能。

例如：count=7次，sum=7次的值求值。

它提供一个quantiles的功能，可以按%比划分跟踪的结果。例如：quantile取值0.95，表示取采样值里面的95%数据。


[使用 prometheus + grafana 做性能测试图形化输出](http://blog.makerome.com/2017/03/11/use-promethues-and-grafana-as-perfomance-report.html)

[图形展示看这里](https://www.howtoing.com/how-to-add-a-prometheus-dashboard-to-grafana/)



https://www.addops.cn/post/Prometheus-first-exploration.html


这里的 irate() 为 promethues 的查询函数.与之对应的是rate().

这两个函数在 promethues 中经常用来计算增量或者速率,在使用时需要指定时间范围如[1m]

irate(): 计算的是给定时间窗口内的每秒瞬时增加速率.
rate(): 计算的是给定时间窗口内的每秒的平均值.

[Prometheus 初探](https://www.addops.cn/post/Prometheus-first-exploration.html)