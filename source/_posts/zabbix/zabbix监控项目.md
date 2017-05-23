1. zabbix 每个核  平均5分钟 user占用时间 百分比
zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.discovery"   cpu核数自动发现

[root@ZX-OTT-ZabbixServer cron.d]# zabbix_get -s 127.0.0.1 -p 10050 -k "system.cpu.discovery"
