patching file ./include/func.inc.php
patching file ./include/menu.inc.php



[root@ZX-OTT-ZabbixServer ~]# cd /usr/share/zabbix
[root@ZX-OTT-ZabbixServer zabbix]# 
[root@ZX-OTT-ZabbixServer zabbix]# pwd
/usr/share/zabbix
[root@ZX-OTT-ZabbixServer zabbix]# cd ..
[root@ZX-OTT-ZabbixServer share]# cp -rp zabbix zabbix_bak
[root@ZX-OTT-ZabbixServer share]# cd zabbix
[root@ZX-OTT-ZabbixServer zabbix]# patch -Np0 < /tmp/graphtree3.0.4.patch 


[root@ZX-OTT-ZabbixServer zabbix]# chown -R nginx:nginx oneoaas/ 
