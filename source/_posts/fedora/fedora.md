# fedora 简单环境安装

fedora 中文社区软件源  http://copr-be.cloud.fdzh.org/

https://github.com/FZUG/repo/wiki/Sogou-Pinyin-%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98


# 安装

+ 查看 有哪些目录
smbclient -U monkey-L 172.16.200.250

+ 挂载
sudo mount.cifs //172.16.200.250/Upload /home/monkey/it-fs/Upload -o username=monkey,password=123.coM


sudo mount.cifs //172.16.200.250/Release /home/monkey/it-fs/Release -o username=monkey,password=123.coM

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


+ 安装google  chrome

http://orion.lcg.ufrj.br/RPMS/myrpms/google/
注：fedora24 和 chrome 54.0.2840.100-1.x86_64.rpm 不兼容

+ 安装xx-net 翻墙
安装fedora中国 源之后
dnf install xx-net

+ 系统升级
sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade
sudo dnf system-upgrade download --refresh --releasever=25 --allowerasing --best --nogpgcheck
## 请加上--nogpgcheck 否则可以会因为某些key没有安装 出现无法安装

sudo dnf system-upgrade reboot
+ 升级后key会变，在下面网站 找寻对应的key替换

https://getfedora.org/keys/

比如fedora25：
$rpm --import PUBKEY https://getfedora.org/static/FDB19C98.txt
+ 安装dock
https://extensions.gnome.org/extension/307/dash-to-dock/

+ open terminal in current folder in fedora?
    - Open Terminal and type sudo yum install nautilus-open-terminal
    - Log Off and log on
    - Now, in any folder, if you right click you will have the option Open in Terminal, which opens the terminal in the current directory.

+ 在终端中打开 目录
    $ nautilus .


+ 添加 更新软件源  安装 mpv 播放器
rpm -Uvh http://mirrors.aliyun.com/rpmfusion/free/fedora/rpmfusion-free-release-25.noarch.rpm
rpm -Uvh http://mirrors.aliyun.com/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-25.noarch.rpm



yum install mpv