Prometheus  时间序列数据库 一般用来实现docker的监控

Zabbix metrics exporter for Prometheus
https://github.com/MyBook/zabbix-exporter

把zabbix的数据导出到Prometheus  然后用Prometheus做源，给grafana监控 



prometheus各个组件：
Prometheus server 分拣和储存时间序列的数据
client libraries ： 客户端库
push gateway  ： push模式代理
专门的exporters： （HAProxy, StatsD, Graphite等）


Prometheus server
Alertmanager
WebUI/grafana



启动：
docker run -p 9090:9090 prom/prometheus


查询：
quantile 


prometheus_target_interval_length_seconds{quantile="0.99"}

好的资料，为ppt提供依据：
http://www.10tiao.com/html/345/201703/2651825087/1.html

prometheus使用：
https://github.com/songjiayang/prometheus_practice/

https://songjiayang.gitbooks.io/prometheus/content/pushgateway/why.html
http://www.songjiayang.com/page2/
https://github.com/pingcap/docs-cn/blob/master/op-guide/monitor.md
https://www.addops.cn/post/Prometheus-first-exploration.html
https://yami.io/golang-prometheus/
http://www.debugrun.com/a/Ho02vpe.html
http://blog.shurenyun.com/shurenyun-sre-256/


中文文档：
https://github.com/1046102779/prometheus/blob/master/alerting/clients.md

ppt:
https://www.slideshare.net/brianbrazil/prometheus-overview



Prometheus 集成 OneAlert:
http://www.songjiayang.com/technical/prometheus-with-alertmanager/