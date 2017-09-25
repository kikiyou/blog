数据源：
cat /proc/stat

+ node_boot_time

    node_boot_time 1.50616336e+09
    使用的是科学计数法，也就是1.50616336 * （10的9次方） -> 1506163360 换成北京时间2017/9/23 18:42:40

+ node_forks
其实和这个数值是一样的
cat /proc/stat | grep processes

表示：
“processes (total_forks) 自系统启动后所创建过的进程数量。短时间该值特别大，系统可能出现异常
node_procs_running “procs_running”：处于Runnable状态的进程个数。
node_procs_blocked “procs_blocked”：处于等待I/O完成的进程个数。

+ node_intr
cat /proc/stat | grep intr
内核记录的系统从启动以来的中断数，第一列表示所有的中断数。后续的每一列都表示一个特定中断的总数。

