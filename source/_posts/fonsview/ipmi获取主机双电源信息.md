超微服务器电源状态查看方法

使用命令：ipmitool

软件包：ipmitool-1.8.15-2.el6.x86_64.rpm

超威服务器检测方法：
0. 查看服务器信息
[root@root ~]# ipmitool mc info
Manufacturer Name         : Supermicro
可以查看到如上字样，表明是超微服务器

1. 使用 ipmitool sensor

正常： 
[root@root ~]# ipmitool sensor | grep PS
PS1 Status       | 0x1       | discrete   | 0x0100| na        | na        | na        | na        | na        | na        
PS2 Status       | 0x1        | discrete   | 0x0100| na        | na        | na        | na        | na        | na 


如上可知，有两条电源线，分别为PS1 和 PS2， 现在我拔掉电源线PS1

异常：
[root@k8s-master ~]# ipmitool sensor | grep PS
PS1 Status       | 0xb       | discrete   | 0x0b00| na        | na        | na        | na        | na        | na        
PS2 Status       | 0x1        | discrete   | 0x0100| na        | na        | na        | na        | na        | na 

如上可知，PS1 Status的状态变为 0xb，表示异常，电源线被拔出

2. 使用 ipmitool sdr
正常： 
[root@k8s-master ~]# ipmitool sdr | grep "PS"
PS1 Status       | 0x01             | ok
PS2 Status       | 0x01              | ok

如上可知，有两条电源线，分别为PS1 和 PS2， 现在我拔掉电源线PS1

异常：
[root@k8s-master ~]# ipmitool sdr | grep "PS"
PS1 Status       | 0x0b             | ok
PS2 Status       | 0x01              | ok

如上可知，PS1 Status的状态变为 0x0b，表示异常，电源线被拔出

3. 使用 ipmitool sel list 查看日志记录
   4 | 06/05/2017 | 09:21:18 | Power Supply #0xc8 | Failure detected | Asserted    #拔出时日志
   5 | 06/05/2017 | 09:29:15 | Power Supply #0xc8 | Failure detected | Deasserted  #插入时日志


无法解决问题：
1. 同样属于超微服务器，但是四子星服务器中使用ipmitool sensor 没有 PS1 Status 和  PS2 Status 状态，
故无法监控主备电源状态

影响：
以EPG服务器为代表的,使用四字星的服务器无法监控主备电源状态

具体需要联系超微服务器厂商，提供解决方案。


常见错误处理:
[root@root ~]# ipmitool mc info 
Could not open device at /dev/ipmi0 or /dev/ipmi/0 or /dev/ipmidev/0: No such file or directory

如上表明，没有加载 ipmi支持的内核模块，使用如下命令解决：
modprobe ipmi_msghandler
modprobe ipmi_devintf
modprobe ipmi_si



补充命令：

清除历史日志：
ipmitool sel clear
ipmitool sel list


获取详细状态：
ipmitool sensor get  "PS1 Status"

不同主板，电源线被拔出，显示的报错 符号不一致

1. x10 主板  电源线拔出  0x0
2. x9 主板  电源线拔出  0x3
2. x8 主板  电源线拔出  0xb