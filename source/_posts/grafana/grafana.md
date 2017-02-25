1. grafana

+ 下载
docker run -d --name=grafana-xxl -p 3000:3000 monitoringartist/grafana-xxl:latest


+ 运行：
docker run -d -v /var/lib/grafana --name grafana-xxl-storage busybox:latest


docker run \
  -d \
  -p 3000:3000 \
  --name grafana-xxl \
  --volumes-from grafana-xxl-storage \
  monitoringartist/grafana-xxl:latest


+ 添加zabbix监控
0. 把zabbix enable
1. Data Source --> Add data source -->

Name zabbix
Type zabbix
Url http://xxxxx/zabbix/api_jsonrpc.php
zabbix api details
username Admin
Password zabbix
Trends enable


+ 添加图形

0. ADD ROW  选 Graph
1. 左键上标题栏   选择 edite
2. Metrics(度量) 中 Panel data source(面板数据源)这里选择zabbix
3. Metrics中 
   Group 填入 $group   Host 填入 $host
   Application 空      Item 填入 网卡
4. 如果想把 出和入两个流量合并  可以再选择  Add query添加一栏 或者 右边选项里面选复制


+ 导出vsv 所有图片，选右键 选项这里可以导出到csv