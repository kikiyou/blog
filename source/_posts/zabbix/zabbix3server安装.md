zabbix使用教程1：zabbix3Server安装
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
安装依赖：
php 版本大于等于 php 5.4.0	
PHP gd	大于等于	2.0
PHP libxml	大于等于	2.6.15

php 设置：


注： 推荐 mysql 设置  innodb_file_per_table=1 使用独立表空间

0. 设置软件仓库
下载:
 \\it-fs\Upload\SS Department\monkey\zabbix\fsv_zabbix3.tar.gz

mkdir -p /root/install/
tar xf fsv_zabbix3.tar.gz -C /root/install/


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
shell> cat << _EOF > ~/.my.cnf
[client]
host= localhost
user = root
password = "Mysql23+"
_EOF

2. 卸载旧版 php相关
yum remove php*

3. php56 安装

yum --enablerepo=fsv_zabbix install php php-mysql php-gd php-bcmath php-common php-mbstring php-xml

4. 安装zabbix
yum --enablerepo=fsv_zabbix install zabbix-server-mysql zabbix-web zabbix-web-mysql zabbix-agent.x86_64

4. 查看当前主机 php版本
php -v
PHP 5.6.30 (cli) (built: Jan 19 2017 08:09:42)
查看软件包 是否已经安装
rpm -q zabbix-server-mysql

5. 修改PHP的设定
sed -i -e "s/memory_limit = 128M/memory_limit = 256M/g" /etc/php.ini
sed -i -e "s/post_max_size = 8M/post_max_size = 16M/g" /etc/php.ini
sed -i -e "s/max_execution_time = 30/max_execution_time = 300/g" /etc/php.ini
sed -i -e "s/max_input_time = 60/max_input_time = 300/g" /etc/php.ini
sed -i -e "s/;date.timezone =/date.timezone = Asia\/Shanghai/g" /etc/php.ini
sed -i -e "s/;always_populate_raw_post_data = On/always_populate_raw_post_data = -1/g" /etc/php.ini

6. 创建数据库
shell> mysql -uroot
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to zabbix@localhost identified by 'Mysql23+';
mysql> quit;

7. 数据库导入  （注：需要等待三分钟）
shell> zcat /usr/share/doc/zabbix-server-mysql-3.0.*/create.sql.gz | mysql zabbix

8. 修改zabbix-server的配置

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
StartPollers=30
StartPollersUnreachable=3
StartTrappers=5
StartPingers=5
StartDiscoverers=5
MaxHousekeeperDelete=20000
CacheSize=256M
StartDBSyncers=4
HistoryCacheSize=256M
ValueCacheSize=256M
TrendCacheSize=8M
HistoryTextCacheSize=32M
_EOF

9. 修改客户端的配置
shell> cat << _EOF > /etc/zabbix/zabbix_agentd.conf
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=127.0.0.1
ServerActive=127.0.0.1
Hostname=Zabbix server
Include=/etc/zabbix/zabbix_agentd.d/
_EOF

10. 配置web
cp  /usr/share/doc/zabbix-web-3*/httpd22-example.conf /etc/httpd/conf.d/zabbix.conf 

chown apache:apache -R /usr/share/zabbix
chown  apache:apache -R /etc/zabbix/

11. 启动服务
chkconf zabbix-agent on
/etc/init.d/zabbix-agent restart 

chkconf zabbix-server on
/etc/init.d/zabbix-server restart

chkconf httpd on
/etc/init.d/httpd restart


12. 检查
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

##############
zabbix忘记密码，重置密码方法
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
