# fedora 简单环境安装

fedora 中文社区软件源  http://copr-be.cloud.fdzh.org/

https://github.com/FZUG/repo/wiki/Sogou-Pinyin-%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98


# 安装

+ 查看 有哪些目录
smbclient -L 172.16.200.250

+ 挂载
sudo mount.cifs //172.16.200.250/Upload /home/monkey/it-fs/Upload -o username=monkey,password=123.coM

sudo mount.cifs //172.16.200.250/Public /home/monkey/it-fs/Public -o username=monkey,password=123.coM

+ plank 小巧好用的dock
 dnf install plank

主机如下：
Hi Monkey：
            欢迎加入FonsView！
            你需要的虚拟机信息如下：
主机信息
云主机名	虚拟内核	内存	根分区	云硬盘	云主机IP	ssh端口	操作系统	账户	密码	使用者
Monkey1	4	8	20G	100G	172.16.199.119	50000	centos7.1	fonsview	FonsView!23+	Monkey
Monkey2	4	16	20G	300G	172.16.199.120	50000	centos6.3	fonsview	FonsView!23+	Monkey



