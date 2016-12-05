如果大家在使用 虚拟主机的过程中
根分区 空间不够，使用如下方法 可以给根分区扩充50G
注：扩充过程中数据不会有任何损坏

1. 把空闲磁盘 vdb 转换为物理卷（如果没有vdb，请联系管理人员添加磁盘）
[root@fonsview ~]#pvcreate /dev/vdb

2. 把/dev/vdb 添加到卷组 VolGroup00中
[root@fonsview ~]#vgextend VolGroup00 /dev/vdb

3. 扩充根逻辑卷VolGroup00-LogVol00   并把文件系统增大50G
[root@fonsview ~]#lvresize --resizefs --size +50GB /dev/mapper/VolGroup00-LogVol00

名词解释：
空闲磁盘的意思是 没有分区 没有挂载 没有使用