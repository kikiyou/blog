centos7 配置使用阿里的yum源-使用curl

1. 创建备份目录
mkdir -p /etc/yum.repos.d/bak

2. 把老的配置移到备份目录
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/

3. 清楚yum缓存
yum clean all

4. 下载yum源配置

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

5. 重新生成缓存
yum makecache

6. 下载软件包到本地
mkdir /tmp/ansible

yum install ansible --downloadonly --downloaddir=/tmp/ansible/



centos6 配置使用阿里的yum源

1. 创建备份目录
mkdir -p /etc/yum.repos.d/bak

2. 把老的配置移到备份目录
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/

3. 清楚yum缓存
yum clean all

4. 下载yum源配置

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

5. 重新生成缓存
yum makecache

6. 下载软件包到本地
mkdir /tmp/ansible

yum install ansible --downloadonly --downloaddir=/tmp/ansible/