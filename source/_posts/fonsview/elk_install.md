
# elk安装

## 依赖
java8

export ES_JAVA_OPTS = "-Xms16038.5m -Xmx16038.5m -Xmn6014.4375m -XX:MaxDirectMemorySize=16038.5m"
## 软件包
elasticsearch-5.2.2.rpm
filebeat-5.2.2-x86_64.rpm
kibana-5.2.2-x86_64.rpm
logstash-5.2.2.rpm


vi /etc/security/limits.conf
elasticsearch soft nofile 65536
elasticsearch hard nofile 131072
elasticsearch soft nproc 2048
elasticsearch hard nproc 4096

vi /etc/sysctl.conf 
vm.max_map_count=655360


在elasticsearch.yml中配置bootstrap.system_call_filter为false，注意要在Memory下面:
bootstrap.system_call_filter: false
# 增加新的参数，这样head插件可以访问es
http.cors.enabled: true
http.cors.allow-origin: "*"

## 启动
su - elasticsearch  -s /bin/bash
/usr/share/elasticsearch/bin/elasticsearch -p /var/run/elasticsearch/elasticsearch.pid -d -Edefault.path.logs=/var/log/elasticsearch -Edefault.path.data=/var/lib/elasticsearch -Edefault.path.conf=/etc/elasticsearch


## 报错处理
[root@ZX-OTT-ZabbixServer elasticsearch]# /etc/init.d/elasticsearch start 
Starting elasticsearch: Error: encountered environment variables that are no longer supported
Use jvm.options or ES_JAVA_OPTS to configure the JVM
ES_HEAP_SIZE=16038.5m: set -Xms16038.5m and -Xmx16038.5m in jvm.options or add "-Xms16038.5m -Xmx16038.5m" to ES_JAVA_OPTS


export ES_JAVA_OPTS="-Xms16038.5m -Xmx16038.5m -Xmn6014.4375m -XX:MaxDirectMemorySize=16038.5m"



logstash
cd /usr/share/logstash
ln -s /etc/logstash ./config


/usr/share/logstash/bin/logstash -e 'input { stdin{} } output { stdout{ codec => rubydebug} }'

/usr/share/logstash/vendor/bundle/jruby/1.9/gems/logstash-patterns-core-4.0.2/patterns



/usr/share/logstash/bin/logstash -f  /etc/logstash/logstash.yml

/usr/share/logstash/bin/system-install



生成logstash 启动脚本
/usr/share/logstash/bin/system-install /etc/logstash/startup.options  sysv
