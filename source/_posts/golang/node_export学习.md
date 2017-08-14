
getSecondsSinceLastLogin

who /var/log/wtmp -l -u -s





getLoad（）

cat /proc/loadavg
0.41 0.46 0.46 2/984 16708
分别代表的意思是：1分钟负载，5分钟负载，和10分钟负载  第四个字段表示，当前运行的进程数和总进程数 第五个字段表示，上个运行的进程id




const (
	procLoad       = "/proc/loadavg"
	procMemInfo    = "/proc/meminfo"
	procInterrupts = "/proc/interrupts"
	procNetDev     = "/proc/net/dev"
	procDiskStats  = "/proc/diskstats"
)