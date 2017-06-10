# wireshark过滤规则

wireshark的过滤规则 是（BPF,Berkeley Packet Filtering）
这个过滤规则是通用的行业标准

具体过滤语法可参考这里[Berkeley Packet Filter (BPF) syntax](http://biot.com/capstats/bpf.html)



wireshark 颜色定义规则 可以在frame
Coloring Rule String: http || tcp.port == 80 || http2
这里看到

wireshark右下角 状态栏（status Bar）可以配置用户的环境配置，其中... 右键可以选择你需要的配置
比如：
Default
classic
bluetooth
等

+ 搜索数据包中包含的内容
http contains "text"


+tcp三次握手

A -> B  SYN
B -> A  SYN-ACK
A -> B  ACK