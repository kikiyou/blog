zabbix使用教程1：zabbix3Server安装


nginx 版本： 1.10.2-1.el6.ngx
zabbix版本：
zabbix_server: 3.0.7
zabbix_agentd: 3.2.3

一、环境介绍
[root@centos63 ~]# cat /etc/redhat-release
CentOS release 6.3 (Final)
[root@centos63 ~]# uname -a
Linux centos63 2.6.32-279.el6.x86_64 #1 SMP Fri Jun 22 12:19:21 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

IP地址	角色
安装软件	操作系统
192.168.122.18	服务器端+被监控端+数据库存储
zabbix-web、zabbix-server、zabbix-agent、mysql，php5.6，httpd	centos6.3

二、软件包安装
安装依赖（fsv_zabbix3_nginx.tar.xz 中已提供）：
php 版本大于等于 php 5.4.0	
PHP gd	大于等于	2.0
PHP libxml	大于等于	2.6.15

php 设置：


注： 推荐 mysql 设置  innodb_file_per_table=1 使用独立表空间
如下为zabbix 调优建议
##zabbix tuning
innodb_file_per_table=1
event_scheduler=ON
wait_timeout=600
sync_binlog=500 
query_cache_type=0
query_cache_size=0
innodb_flush_method = O_DIRECT
innodb_io_capacity  = 2000
innodb_old_blocks_time = 1000
innodb_buffer_pool_size=10G
innodb_buffer_pool_instances=16
innodb_flush_log_at_trx_commit=0
innodb_log_file_size = 512M
innodb_log_buffer_size  = 128M
#tmpdir = /dev/shm/mysql
##zabbix -end


注意： 本教程 默认mysql 密码是Mysql23+   如果不是，请修改
注意： 本教程 默认mysql 密码是Mysql23+   如果不是，请修改
注意： 本教程 默认mysql 密码是Mysql23+   如果不是，请修改


0. 设置软件仓库
下载:
 \\it-fs\Upload\SS Department\monkey\zabbix\fsv_zabbix3_nginx.tar.xz

mkdir -p /root/install/
tar xf fsv_zabbix3_nginx.tar.xz -C /root/install/


清除 默认无用的仓库

mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/

cat << _EOF > /etc/yum.repos.d/fsv_zabbix.repo
[fsv_zabbix]
name=fonsview repo
baseurl=file:///root/install/fsv_zabbix3/6/
enabled=0
gpgcheck=0
_EOF


1. 创建mysql 登录认证文件
cat << _EOF > ~/.my.cnf
[client]
host= localhost
user = root
password = "Mysql23+"
_EOF

2. 卸载旧版 php相关
yum clean all
yum remove php*

3. php56 安装

yum --enablerepo=fsv_zabbix install php php-fpm php-mysql php-gd php-bcmath php-common php-mbstring php-xml

4. 安装zabbix
yum --enablerepo=fsv_zabbix install zabbix-server-mysql zabbix-web zabbix-web-mysql  zabbix-agent.x86_64 zabbix-get

5. 安装nginx
yum --enablerepo=fsv_zabbix install nginx

6. 修改文件权限
sed -i "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf

7. 查看当前主机 php版本
php -v
PHP 5.6.30 (cli) (built: Jan 19 2017 08:09:42)
查看软件包 是否已经安装
rpm -q zabbix-server-mysql

8. 查看当前nginx版本
[root@centos63 yum.repos.d]# nginx -V
nginx version: nginx/1.10.2

9. 修改PHP的设定
sed -i -e "s/memory_limit = 128M/memory_limit = 256M/g" /etc/php.ini
sed -i -e "s/post_max_size = 8M/post_max_size = 16M/g" /etc/php.ini
sed -i -e "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php.ini
sed -i -e "s/max_input_time = 60/max_input_time = 300/g" /etc/php.ini
sed -i -e "s/;date.timezone =/date.timezone = Asia\/Shanghai/g" /etc/php.ini
sed -i -e "s/;always_populate_raw_post_data = On/always_populate_raw_post_data = -1/g" /etc/php.ini
sed -i -e "s/;always_populate_raw_post_data = -1/always_populate_raw_post_data = -1/g" /etc/php.ini

10. 创建数据库
shell> mysql -uroot
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'Mysql23+';
mysql> quit;

11. 数据库导入  （注：需要等待三分钟）
shell> zcat /usr/share/doc/zabbix-server-mysql-3.0.*/create.sql.gz | mysql zabbix

12. 修改zabbix-server的配置

修改配置：
shell> cat << _EOF > /etc/zabbix/zabbix_server.conf
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_server.pid
DBName=zabbix
DBUser=zabbix
DBPassword=Mysql23+
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
StartPollers=40
StartPollersUnreachable=3
StartTrappers=10
StartPingers=10
StartDiscoverers=10
MaxHousekeeperDelete=20000
CacheSize=256M
StartDBSyncers=4
HistoryCacheSize=256M
ValueCacheSize=256M
TrendCacheSize=16M
HistoryCacheSize=32M
HistoryIndexCacheSize=16M
_EOF

13. 修改客户端的配置
shell> cat << _EOF > /etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=Zabbix server
Include=/etc/zabbix/zabbix_agentd.d/
_EOF

14. 配置zabbix web
mv /etc/nginx/conf.d/default.conf  /etc/nginx/conf.d/default.conf_bak

vi /etc/nginx/conf.d/zabbix.conf
server { 
    location /zabbix { 
    alias /usr/share/zabbix;
    index index.php index.php ; 
}  
    location ~ \.php$ { include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /usr/share/$fastcgi_script_name; 

  } 
}


chown nginx:nginx  /usr/share/zabbix/ -R
chown nginx:nginx -R /etc/zabbix/
chown root:nginx /var/lib/php/session/
chown nginx:nginx /var/lib/php/session/*

15. 启动服务
chkconfig zabbix-agent on
service zabbix-agent restart 

chkconfig zabbix-server on
service zabbix-server restart

chkconfig php-fpm on
service php-fpm restart

chkconfig nginx on
service nginx restart


16. 检查
[root@rhel6 ~]#/etc/init.d/zabbix-server status

1.查看是zabbix_server否启动正常
(1)查看端口是否侦听
 [root@rhel6 ~]# netstat -anlp | grep 10051
tcp        0      0 0.0.0.0:10051               0.0.0.0:*                   LISTEN      5636/zabbix_server  
tcp        0      0 :::10051                    :::*                        LISTEN      5636/zabbix_server  
####因为默认情况下zabbix_server侦听的是10051端口  如上查看可以zabbix_server已经侦听
（2）查看日志
 [root@rhel6 ~]# cat /var/log/zabbix/zabbix_server.log
  6006:20170119:214734.849 Starting Zabbix Server. Zabbix 3.0.7 (revision 64609).
  6006:20170119:214734.849 ****** Enabled features ******
  6006:20170119:214734.850 SNMP monitoring:           YES
  6006:20170119:214734.850 IPMI monitoring:           YES
  6006:20170119:214734.850 Web monitoring:            YES
  6006:20170119:214734.850 VMware monitoring:         YES
  6006:20170119:214734.850 SMTP authentication:        NO
  6006:20170119:214734.850 Jabber notifications:      YES
  6006:20170119:214734.850 Ez Texting notifications:  YES
  6006:20170119:214734.850 ODBC:                      YES
  6006:20170119:214734.850 SSH2 support:              YES
  6006:20170119:214734.850 IPv6 support:              YES
  6006:20170119:214734.850 TLS support:               YES
  6006:20170119:214734.850 ******************************
  6006:20170119:214734.850 using configuration file: /etc/zabbix/zabbix_server.conf


2.查看zabbix_agentd 是否启动正常
 [root@rhel6 ~]#/etc/init.d/zabbix-agent status
(1)查看侦听
###默认情况下 zabbix_agentd侦听10050端口
[root@centos63 httpd]# netstat -anlp | grep 10050
tcp        0      0 0.0.0.0:10050               0.0.0.0:*                   LISTEN      5569/zabbix_agentd
（2）查看日志
[root@centos63 httpd]# cat /var/log/zabbix/zabbix_agentd.log
  5569:20170119:210723.409 Starting Zabbix Agent [Zabbix server]. Zabbix 3.0.7 (revision 64609).
  5569:20170119:210723.409 **** Enabled features ****
  5569:20170119:210723.409 IPv6 support:          YES
  5569:20170119:210723.409 TLS support:           YES
  5569:20170119:210723.409 **************************
  5569:20170119:210723.409 using configuration file: /etc/zabbix/zabbix_agentd.conf
###如上说明zabbix_agetd 启动正常


六、通过web管理
访问http://192.168.122.18/zabbix 进行安装

数据库的 库名：zabbix 用户名：zabbix  密码：Mysql23+


七、登录
通过如上安装后就可以登录了：
zabbix默认
用户名:Admin     (第一个A是大写)
密码:zabbix



nginx优化与加固：

1. 优化
sed -i -e "s/#tcp_nopush     on;/tcp_nopush     on;/g" /etc/nginx/nginx.conf
sed -i -e "s/#gzip  on;/gzip  on;/g" /etc/nginx/nginx.conf

2. 加固
隐藏nginx版本：
sed -i -e '/keepalive_timeout/aserver_tokens  off;' /etc/nginx/nginx.conf
/etc/init.d/nginx restart

隐藏php版本：
sed -i -e '/expose_php = On/expose_php = Off' /etc/php-fpm.d/www.conf
/etc/init.d/php-fpm restart

检查：
curl -I 127.0.0.1/index.php

有如下输出：
HTTP/1.1 302 Moved Temporarily
Server: nginx
Date: Fri, 17 Feb 2017 01:51:36 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
Location: setup.php

如上 没有显示如下，无法从外部判断 nginx版本号 和 php版本即可
X-Powered-By: PHP/5.6.30
Server: nginx/1.10.3

##############
可能出错 标注：
1. php 无法解析   （白屏）
 （1）php-fpm 没有启动
 （2）php-fpm权限异常，如下可解决

sed -i "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf
chown nginx:nginx  /usr/share/zabbix/ -R
chown  nginx:nginx -R /etc/zabbix/
/etc/init.d/php-fpm restart

2. 一直停留在 setup.php 页面，无法进入下一步
原因： php 的session无法保存，session目录权限异常

执行如下命令可解决：
chown root:nginx /var/lib/php/session/
chown nginx:nginx /var/lib/php/session/*

3. zabbix忘记密码，重置密码方法

此方法是通过进入数据库更改密码，操作步骤如下：
mysql> use zabbix;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A
Database changed
查看数据有那些表
mysql> show tables;
查看是否存放用户、密码信息
mysql> select userid,alias,name,passwd from users;
+--------+-------+--------+----------------------------------+
| userid | alias | name   | passwd                           |
+--------+-------+--------+----------------------------------+
|      1 | Admin | Zabbix | 5fce1b3e34b520afeffb37ce08c7cd66 |
|      2 | guest |        | d41d8cd98f00b204e9800998ecf8427e |
+--------+-------+--------+----------------------------------+
2 rows in set (0.00 sec)
如上可以默认管理员用户为Admin 
更改密码为zabbix
mysql> update  users set passwd=md5("zabbix") where userid='1';
Query OK,0 rows affected (0.01 sec)
Rows matched:1Changed:0Warnings:0
zabbix 的用户密码是使用md5的方式进行的加密 ，上面的mysql语句执行后，admin 管理员用户的密码就会改为zabbix 。
####################
