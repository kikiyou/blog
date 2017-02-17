1. 打开yum cache保留
sed -i 's/keepcache=1/keepcache=1/g' /etc/yum.conf

2.  软件源 添加
mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/
yum clean all

curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

cat << _EOF > /etc/yum.repos.d/zabbix.repo
[zabbix]
name=Zabbix Official Repository - $basearch
baseurl=http://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/6/$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX

[zabbix-non-supported]
name=Zabbix Official Repository non-supported - $basearch 
baseurl=http://mirrors.aliyun.com/zabbix/non-supported/rhel/6/$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=0
_EOF

cat << _EOF > /etc/yum.repos.d/remi.repo
[remi-php56]
name=Remi's PHP 5.6 RPM repository for Enterprise Linux 6 - $basearch
#baseurl=http://rpms.remirepo.net/enterprise/6/php56/$basearch/
mirrorlist=http://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/6/php56/mirror
# NOTICE: common dependencies are in "remi-safe"
enabled=0
gpgcheck=0
_EOF



安装：
1. 
yum install zabbix-server-mysql zabbix-web zabbix-web-mysql zabbix-get

yum --nogpgcheck --enablerepo=remi-php56 --disablerepo=base,updates install nginx  php php-fpm php-mysql php-common-5.6.30-1.el6.remi.x86_64 php-pdo-5.6.30-1.el6.remi.x86_64

yum remove mysql-libs-5.1.73-7.el6.x86_64

yum install install zabbix-get











vi /etc/php-fpm.d/www.conf
; Note: This value is mandatory.
listen = 127.0.0.1:9000







[root@master ~]# cat /etc/nginx/conf.d/zabbix.conf
server {
    location /zabbix {
            root   /usr/share/zabbix;
            index index.php index.html;
            access_log   /var/log/nginx/access_zabbix.log;
            error_log   /var/log/nginx/error_zabbix.log;
        }
    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 4 256k;
        fastcgi_busy_buffers_size 256k;
    }
    location ~ \.(jpg|jpeg|gif|png|ico)$ {
    access_log	off;
    expires		33d;
    }
}