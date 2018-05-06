# 联邦 prometheus联合.md

联邦有不同的用例。
它通常用于实现可扩展的prometheus，或者将metrics从一个服务的prometheus拉到另一个Prometheus上用于展示。



1. 分层联邦
在这种用例中，联邦拓扑类似于一棵树，更高级别的普罗米修斯服务器从大量的从属服务器收集汇总的时间序列数据。
金字塔架构。

2. 跨服务器联邦
在跨服务联合中，一个服务的普罗米修斯服务器被配置为从另一个服务的普罗米修斯服务器中刮取选定的数据，以使得能够针对单个服务器内的两个数据集进行警报和查询
【举个例子：我们要监控mysqld的运行状态，可以使用1个主Prometheus+2个分片Prometheus(一个用来采集node_exporter的metrics、一个用来采集mysql_exporter的metrics)，然后在主Prometheus上做汇总】


3. 使用
目标地址： /federate 被用来作为数据查询入口，可用来由一个server 抓取另一个server的数据
match[] 参数必须被指定,它用来匹配job等级的数据，如果指定多个匹配，则所有匹配的系列的都将被抓取。
指定`honor_labels: true` 参数，将不会覆盖原始抓取的数据


```yaml
- job_name: 'federate'
  scrape_interval: 15s

  honor_labels: true
  metrics_path: '/federate'

  params:
    'match[]':
      - '{job="prometheus"}'
      - '{__name__=~"job:.*"}'

  static_configs:
    - targets:
      - 'source-prometheus-1:9090'
      - 'source-prometheus-2:9090'
      - 'source-prometheus-3:9090'
```

Shard节点 节点，也叫数据中心节点 设置如下：
```
global: 
  external_labels:
    datacenter: eu-west-1

rule_files:
  - node.rules

scrape_configs:
  etc.
```

如上每一个 分片都需要一个独立的外部 标签
比如如下： node.rules 规则文件都汇聚一个分片的聚合输入:

job:node_memory_MemTotal:sum = sum without(instance)(node_memory_MemTotal{job="node"})


如上，根据job： 结构，并且是求和所以是sum，我们就可以使用如下的配置汇聚 分片节点的数据，
``` yml
global:
  external_labels:
    datacenter: global  # In a HA setup, this would be global1 or global2

scrape_configs:
  - job_name: datacenter_federation
    honor_labels: true
    metrics_path: /federate
    params:
      match[]:
        - '{__name__=~"^job:.*"}'
    static_configs:
      - targets:
        - eu-west-1-prometheus:9090

etc.
```
现在你就可以使用sum without(datacenter)(job:node_memory_MemTotal:sum)，来根据数据中心来进行书数据聚合查询了


测速：
curl -G --data-urlencode 'match[]={job!=""}' example.org/federate