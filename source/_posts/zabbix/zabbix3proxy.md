## 注(血的教训)： 
zabbix server 和 zabbix proxy版本 必须 严格对应
比如 
server： 3.0.8 proxy：3.0.8
如下都不兼容：
server： 3.0.7 proxy：3.0.8


zabbix Server 版本查看：
$ zabbix_server -V

zabbix_server (Zabbix) 3.0.8
Revision 65976 27 February 2017, compilation time: Mar  1 2017 01:29:36

zabbix-proxy-sqlite 下载地址：
https://mirrors.aliyun.com/zabbix/zabbix/3.0/rhel/6/x86_64/

# yum install zabbix-proxy-sqlite
# mkdir -p /opt/fonsview/3RD/zabbix_proxy
# cd /opt/fonsview/3RD/zabbix_proxy
# zcat /usr/share/doc/zabbix-proxy-pgsql-3.0.X/create.sql.gz | sqlite3 zabbix.db
# chown zabbix:zabbix /opt/fonsview/3RD/zabbix
# chmod 777 /opt/fonsview/3RD/zabbix_proxy/zabbix.db



[root@ZX-OTT-STSC1 ~]# cat /etc/zabbix/zabbix_proxy.conf |grep -v "#" | grep -v "^$"
ProxyMode=1
Server=1.58.125.132
Hostname=hrb_proxy
ListenPort=30051
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=0
DebugLevel=3
PidFile=/var/run/zabbix/zabbix_proxy.pid
DBName=/opt/fonsview/3RD/zabbix_proxy/zabbix.db
DBUser=zabbix
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000



[root@ZX-OTT-STSC1 ~]# cat /opt/fonsview/3RD/zabbix/zabbix_agentd.conf 
PidFile=/var/run/zabbix/fsv-zabbix-agent.pid
LogType=file
LogFile=/var/log/zabbix/fsv-zabbix-agent.log
LogFileSize=1
EnableRemoteCommands=0
LogRemoteCommands=0
Server=1.58.125.129
ListenPort=30050
StartAgents=3
Hostname=ZX-OTT-STSC1
RefreshActiveChecks=120
BufferSend=5
BufferSize=100
MaxLinesPerSecond=20
Timeout=20
AllowRoot=0
User=zabbix
Include=/opt/fonsview/3RD/zabbix/zabbix_agentd.d/
UnsafeUserParameters=1
