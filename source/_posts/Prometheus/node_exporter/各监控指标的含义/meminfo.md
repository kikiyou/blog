数据源：
/proc/meminfo

参考：http://linuxperf.com/?p=142

+ node_memory_Active
Active: 在活跃使用中的缓冲或高速缓冲存储器页面文件的大小，除非非常必要否则不会被移作他用.

Active = Active(anon) + Active(file)
Inactive = Inactive(anon) + Inactive(file)

ACTIVE_ANON 和 ACTIVE_FILE，分别表示 anonymous pages 和 mapped pages。用户进程的内存页分为两种：与文件关联的内存（比如程序文件、数据文件所对应的内存页）和与文件无关的内存（比如进程的堆栈，用 malloc 申请的内存），前者称为 file pages 或 mapped pages，后者称为 anonymous pages。file pages 在发生换页(page-in 或 page-out)时，是从它对应的文件读入或写出；anonymous pages 在发生换页时，是对交换区进行读/写操作。

+ node_memory_Active_anon
+ node_memory_Active_file

+ node_memory_AnonHugePages
大页占用大小

+ node_memory_Bounce

+ node_memory_HardwareCorrupted
当系统检测到内存的硬件故障时，会把有问题的页面删除掉，不再使用，/proc/meminfo中的HardwareCorrupted统计了删除掉的内存页的总大小。相应的代码参见 mm/memory-failure.c: memory_failure()。

+ node_memory_MemTotal
系统从加电开始到引导完成，firmware/BIOS要保留一些内存，kernel本身要占用一些内存，最后剩下可供kernel支配的内存就是MemTotal。这个值在系统运行期间一般是固定不变的。可参阅解读DMESG中的内存初始化信息。

+ node_memory_MemFree
表示系统尚未使用的内存。[MemTotal-MemFree]就是已被用掉的内存。

+ node_memory_NFS_Unstable
NFS_Unstable是发给NFS server但尚未写入硬盘的缓存页

+ node_memory_SwapTotal
swap 空间总共
+ node_memory_SwapFree
swap空间剩余

swap使用率 = node_memory_SwapFree / node_memory_SwapTotal