# ansible 报错处理

今天运行ansible的时候报错 

1. 执行 
TASK [common : unarchive jdk-8u60-linux-x64.tar.gz to /opt/fonsview/3RD] *******
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: MemoryError
fatal: [172.16.6.86]: FAILED! => {"failed": true, "msg": "Unexpected failure during module execution.", "stdout": ""}
	to retry, use: --limit @/etc/ansible/sites/epg/src/install_epg.retry

2. 报错类型 The error was: MemoryError

3. 我运行的解压命令  unarchive 其实是 先把主机 copy到远程,然后解压

4. ansible 2.2.0 copy模块有个bug,当copy 大文件时 会报 MemoryError

主要原因是,可用内存 必须 大于 要copy的单个报的大小

我的问题是,我的主机可用内存是150mb,而我copy的 jdk-8u60-linux-x64.tar.gz包 是173MB,
所以内存不够,就报错 The error was: MemoryError

5. 解决方法,释放自己的内存,使可用内存大于 173MB 问题解决