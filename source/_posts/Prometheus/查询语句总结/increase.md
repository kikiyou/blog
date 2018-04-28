#increase()

[参考](https://labs.consol.de/monitoring/2016/08/13/counting-errors-with-prometheus.html)


increase(errors_total[1m])

errors_total[1m],一分钟内获得的错误数据列表，比如prometheus 15秒采集一次,一分钟的数据应该是[2,2,3,4] 


increase(errors_total[1m]) 的结果应该是2

increase，是判断在一定时间内，新增的数据的数量