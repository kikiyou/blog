数据源：
/proc/net/netstat

icmp 统计数据来源：
/proc/net/snmp

参考：
http://www.cnblogs.com/x_wukong/p/5993487.html

+ node_netstat_IcmpMsg_InType0
echo响应 

+ node_netstat_IcmpMsg_InType3
目标不可达

+ node_netstat_IcmpMsg_InType8
进来 Echo请求数量,别人ping你一次这里会加一

+ node_netstat_IcmpMsg_OutType3
出去 目标不可达

+ node_netstat_IcmpMsg_OutType8
出去 Echo请求数量，你ping了别人多少次，ping一次加一

+ node_netstat_Icmp_InAddrMaskReps

+ node_netstat_Icmp_InDestUnreachs

node_netstat_Icmp_InDestUnreachs 和 node_netstat_IcmpMsg_InType3 其实是一个值
InDestUnreachs  : 接收的icmp目的不可达包个数

+ node_netstat_Icmp_InEchoReps

node_netstat_Icmp_InEchoReps 和 node_netstat_IcmpMsg_InType0 其实是一个值
InEchoReps      : 接收的icmp回显应答包数量

+ node_netstat_Icmp_InEchos
node_netstat_Icmp_InEchos 和 node_netstat_IcmpMsg_InType8 其实是一个值

+ node_netstat_Icmp_InErrors
错误的icmp包个数

+ node_netstat_Icmp_InMsgs
收到的icmp包总数

+ node_netstat_Icmp_InTimeExcds
接收的icmp超时包的个数


##IP 层扩展

+ node_netstat_IpExt_InBcastPkts
收到的广播包数量,相当于netstat -s | grep BcastPkts

+ node_netstat_IpExt_InBcastPkts 
收到的多播包数量，相当于netstat -s | grep McastPkts
一般只有tvld使用多播，多播流量监控对tvld有用

##IP 层

+ node_netstat_Ip_DefaultTTL
默认ttl，一般64 （1-255）

+ node_netstat_Ip_ForwDatagrams
IP转发的数据包个数

+ node_netstat_Ip_Forwarding
Forwarding        : 是否开启ip_forward，1开启，2关闭

+ node_netstat_Ip_FragCreates
IP分片发送个数

+ node_netstat_Ip_FragFails
IP分片失败个数

+ node_netstat_Ip_FragOKs
IP分片成功次数

+ node_netstat_Ip_InAddrErrors
IP地址没有找到路由而丢弃的包

+ node_netstat_Ip_InDelivers
IP层向上层传输层递交的数据包

+ node_netstat_Ip_InDiscards
IP层中丢弃的数据包，由于没有内存等原因引起.

+ node_netstat_Ip_InHdrErrors
IP头错误而丢弃的数据包.

+ node_netstat_Ip_InReceives
IP协议处理的数据包.

+ node_netstat_Ip_InUnknownProtos
IP头中的协议未知的数据包个数

+ node_netstat_Ip_OutRequests
IP层向外发送数据包请求的个数，这个包最后不一定真发送出去了.

+ node_netstat_TcpExt_ListenOverflows

+ node_netstat_TcpExt_ListenDrops


## tcp
node_netstat_Tcp_CurrEstab
tcp连接转换到TCP_ESTABLISHED状态的次数