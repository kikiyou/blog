node_cpu{cpu="cpu0",mode="guest"} 0

CPU 关注两个指标： 100-idle，iowait
idle 空闲率
user 用户层执行cpu占用率
iowait io超时时间

irq 硬中断时间
softirq 软中断时间
system 系统层使用时的cpu使用率。
nice 
steal 管理程序维护另一个虚拟处理器时，虚拟CPU的无意识等待时间百分比。
%guest - 任务花费在虚拟机上的cpu使用率（运行在虚拟处理器）。



CPU 占用率计算公式如下:
CPU 时间=user+iowait+system+nice+irq+softirq+steal