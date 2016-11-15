---
title: elk 简单配置
date: 2016-10-10 10:19:44
tags: 
- elk
---
# elk 简单配置
<!-- more -->
[ELK的靠谱安装方法](https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-centos-7)

![本配置实现的模型是](http://7xw819.com1.z0.glb.clouddn.com/elk_stack_filebeat.PNG)

## filebeat.yml 的配置
``` yaml
filebeat:
  prospectors:
    # -
    #   document_type: "messages"
    #   paths:
    #     - /var/log/messages
    # -
    #   document_type: "php-error-5"
    #   paths:
    #     - /home/wwwroot/php_error/php.log

    -
      document_type: "lighttpd-access"
      scan_frequency: "10s"
      backoff: "1s"
      paths:
        - "/var/log/lighttpd/access.log"

  registry_file: /var/lib/filebeat/registry

output:
  logstash:
    hosts: ["127.0.0.1:5000"]
    worker: 4
    compression_level: 3
    loadbalance: true

shipper:
  name: test-web-01
  tags: ["web-server", "lighttpd"]

----
```
## logstash.conf 的配置
```
input {
        beats {
         port => 5000
         }

}
 
## Add your filters / logstash plugins configuration here
filter {
  if [type] == "lighttpd-access" {
     grok {
          match => ["message",  "%{COMMONLIGHTTPDLOG}"]
          remove_field => "message"
          }
        }
}

output {
       elasticsearch {
               hosts => "elasticsearch:9200"
               index => "logstash-%{type}-%{+YYYY.MM.dd}"
       }
 }


-----其中grok中COMMONLIGHTTPDLOG的匹配规则
cd /opt/logstash/vendor/bundle/jruby/1.9/gems/logstash-patterns-core-2.0.5/

cat grok-patterns

COMMONLIGHTTPDLOG %{IPORHOST:client_ip} %{USER:http_user} %{USER:http_auth} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:http_action} %{NOTSPACE:http_request}(?: HTTP/%{NUMBER:http_version})?|%{DATA:rawrequest})" %{NUMBER:http_status_code} (?:%{NUMBER:bytes}|-)
COMBINEDLIGHTTPDLOG %{COMMONLIGHTTPDLOG} %{QS:referrer} %{QS:agent}

------如上规则实现
```
## elasticsearch 

elasticsearch 中索引相当于database
数据清除办法
``` bash
curl -XDELETE 'http://172.16.1.16:9200/logstash-2013.03.*' 
```

（2） 配置ES。这里只做最简单的配置，修改ES_HOME/config/elasticsearch.yml文件， 相关配置参数

```
#集群名称
cluster.name: elasticsearch

#节点名称
node.name: "node1"

#节点是否存储数据
node.data: true

#索引分片数
index.number_of_shards: 5

#索引副本数
index.number_of_replicas: 1

#数据目录存放位置
path.data: /data/elasticsearch/data

#日志数据存放位置
path.logs: /data/elasticsearch/log

#索引缓存
index.cache.field.max_size: 500000

#索引缓存过期时间
index.cache.field.expire: 5m

（3） 启动ES。进入ES安装目录，执行命令：bin/elasticsearch -d -Xms512m -Xmx512m，然后在浏览器输入http://ip:9200/，查看页面信息，是否正常启动。status=200表示正常启动了。
 curl -X GET http://localhost:9200
 检查 ES 是否安装正确
```