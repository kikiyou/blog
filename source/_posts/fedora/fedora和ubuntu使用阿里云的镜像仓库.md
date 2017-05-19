------------fedora
#!/bin/sh
echo 'hello123' | passwd --stdin root
echo 'hello123' | passwd --stdin fedora
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
systemctl  restart sshd
------------------------------ubuntu
#!/bin/sh
passwd ubuntu<<EOF
hello123
hello123
EOF
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service ssh restart

-------------------------------------------
fedora 配置使用阿里的yum源-使用curl

1. 创建备份目录
mkdir -p /etc/yum.repos.d/bak

2. 把老的配置移到备份目录
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/

3. 清楚yum缓存
yum clean all
4. 下载yum源配置
curl  -o /etc/repo.tar.gz  http://hn-1251586848.cosgz.myqcloud.com/repo.tar.gz
tar xf /etc/repo.tar.gz -C /etc/


curl -o /etc/yum.repos.d/fedora.repo http://mirrors.aliyun.com/repo/fedora.repo
curl -o /etc/yum.repos.d/fedora-updates.repo http://mirrors.aliyun.com/repo/fedora-updates.repo

5. 重新生成缓存
dnf makecache


fedora 配置使用阿里的yum源-使用curl

1. 创建备份目录
mkdir -p /etc/yum.repos.d/bak

2. 把老的配置移到备份目录
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/

3. 清楚yum缓存
yum clean all

4. 下载yum源配置

sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

5. 重新生成缓存
+ debian 简单软件包管理
    - apt-get clean && sudo apt-get autoclean  清理仓库
    - apt-get update 更新源
    - apt-cache search package 搜索包
    - apt-get install 安装



----------------
dnf install docker-engine