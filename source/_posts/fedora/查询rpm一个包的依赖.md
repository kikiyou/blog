# 查询rpm包
rpm -qpR ansible-2.2.0.0-3.el6.noarch.rpm

rpm --query --package  --requires ansible-2.2.0.0-3.el6.noarch.rpm

# 查询某个命令是哪个软件包提供的 比如：rz
yum provides */rz

[root@localhost ansible]# yum provides */rz
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: mirrors.aliyun.com
 * epel: mirrors.aliyun.com
 * extras: mirrors.aliyun.com
 * updates: mirrors.aliyun.com
base/filelists_db                                                                                                                                                                           | 6.4 MB     00:47     
extras/filelists_db                                                                                                                                                                         |  38 kB     00:00     
updates/filelists_db                                                                                                                                                                        | 2.5 MB     00:28     
lrzsz-0.12.20-27.1.el6.x86_64 : The lrz and lsz modem communications programs
Repo        : base
Matched from:
Filename    : /usr/bin/rz

如上可知，rz命令是由 lrzsz-0.12.20-27.1.el6.x86_64这个包提供的