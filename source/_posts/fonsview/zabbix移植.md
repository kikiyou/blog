## 本周zabbix梳理表

主做：
1. 网卡接口告警

监控项：
名称：network interface {#IFNAME} status
键值：custom.net.if.status[{#IFNAME}]

触发器:
名字： network interface {#IFNAME} down
表达式：
{Template OS Linux:custom.net.if.status[{#IFNAME}].last(0,86400)}=1 and {Template OS Linux:custom.net.if.status[{#IFNAME}].last(0)}=0
描述：
$$.{"告警附加":"network interface alarm"}









次做：
    4. RRS监控的端口不足，8006/554/8181/6600  这些都是最为常用的
    6.SS的core文件，需要在开启了core文件，才会生成core文件，如果没有开启，在系统根目录检测core文件无效。大多数现场不会轻易开启此开关，更好的方法是通过读取系统日志，检测core关键字来判断。


1. zabbix ss core文件告警  使用grep -c core_pattern /var/log/messages

监控core文件数量  今天比昨天大就告警

