+ node_filesystem_size
文件系统总的磁盘大小

+ node_filesystem_free
文件系统真正物理剩余磁盘空间

+ node_filesystem_avail
文件系统non-root用户可用的空间

注：上面两者很像，数值也比较接近，系统默认会有5%的差别。
因为当磁盘满的时候，root用户要进去删除磁盘空间恢复故障，所以为root用户会保留5%的磁盘空间。
就是文件系统默认情况下，非root用户最多只能写 一块磁盘的95%，root用户可以写100%
node_filesystem_free 表示100%中剩余多少
node_filesystem_avail 表示95%中剩余多少

如果计算磁盘可用率应该使用：
node_filesystem_avail / node_filesystem_size

+ node_filesystem_files
文件系统总的文件inodes数量

+ node_filesystem_files_free
文件系统总的剩余inodes数量

+ node_filesystem_readonly
当前文件是否是只读的,只读是0  非只读是1