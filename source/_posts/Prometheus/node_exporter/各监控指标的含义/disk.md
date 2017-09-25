[参考：深入分析diskstats](http://ykrocku.github.io/blog/2014/04/11/diskstats/)

https://www.kernel.org/doc/Documentation/iostats.txt

http://linuxtools-rst.readthedocs.io/zh_CN/latest/tool/iostat.html


数据源：
cat /proc/diskstats

diskstats：
+ node_disk_bytes_read
磁盘读总量

+ node_disk_bytes_written
磁盘写总量

+ node_disk_io_now
当前每秒io数

+　node_disk_io_time_ms
花在磁盘I/Os上的总的毫秒数

＋ node_disk_io_time_weighted
块设备队列非空闲状态时间加权总和

+ node_disk_read_time_ms
读请求总时间 毫秒

+ node_disk_reads_completed
成功完成的读请求次数

+ node_disk_reads_merged
读请求合并合并总数

+ node_disk_sectors_read
磁盘读扇区总数