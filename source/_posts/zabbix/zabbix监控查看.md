1. cpu 查看 
Processor load (15 min average per core)
表示 每核的负载，就是            系统uptim的值/核数=每核的负载
这个表示 cpu 每秒钟CPU等待运行的进程个数
zabbix 监控 默认值是5 大于5说明这台主机 cpu性能有问题了

CPU user time   在internal时间段里，用户态的CPU时间（%） ，不包含 nice值为负 进程 usr/total*100
CPU iowait time     在internal时间段里，硬盘IO等待时间（%） iowait/total*100
CPU idle time   在internal时间段里，CPU除去等待磁盘IO操作外的因为任何原因而空闲的时间闲置时间 （%） idle/total*100

主要监控 这三个值  
1. user 过高  说明负载高
2. iowait 过高  说明 磁盘写入有问题
3. idle 过低  说明 cpu很繁忙  瓶颈在cpu