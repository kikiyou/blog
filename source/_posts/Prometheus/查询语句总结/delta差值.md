# delta() 返回 list中第一个点到最后一个点的差值

下面这个表达式例子，返回过去两小时的CPU温度差：

delta(cpu_temp_celsius{host="zeus"}[2h])

delta函数返回值类型只能是gauges。



delta 和 increase 不太一样的地方是：
delta ： 都是正的， 表示差值 相差多少，
increase：  有正负，是最后一个减第一个，有正负。