

[root@ZX-OTT-ZabbixServer ~]# cd /usr/share/zabbix
[root@ZX-OTT-ZabbixServer zabbix]# 
[root@ZX-OTT-ZabbixServer zabbix]# pwd
/usr/share/zabbix
[root@ZX-OTT-ZabbixServer zabbix]# cd ..
[root@ZX-OTT-ZabbixServer share]# cp -rp zabbix zabbix_bak
[root@ZX-OTT-ZabbixServer share]# cd zabbix
[root@ZX-OTT-ZabbixServer zabbix]# cd zabbix /tmp/graphtree3.0.4.patch 


[root@ZX-OTT-ZabbixServer zabbix]# chown -R nginx:nginx oneoaas/ 


0. 
修改这里 ./include/menu.inc.php
把  Graphtree 改为图形树



vi /usr/share/zabbix/oneoaas/templates/graphtree/graphtree.tpl
删除多余的信息