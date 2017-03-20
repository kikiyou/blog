---
title: docker elk 安装
date: 2016-10-09 11:31:44
tags: 
- elk
---
# docker elk 安装
<!-- more -->
## docker 安装

+ 安装

[root@rhel7 ~] dnf install docker

+ 运行docker服务
 
[root@rhel7 ~]#systemctl  start docker

[root@rhel7 ~]#systemctl enable docker
 

## 安装Docker-compose
``` bash
curl -L https://github.com/docker/compose/releases/download/1.8.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose
```

* 查看版本

[root@rhel7 ~]# docker-compose --version

docker-compose version 1.8.1, build 878cff1


## 使用阿里云的加速器

注册阿里云开发者帐号帐号
https://cr.console.aliyun.com/

登陆后取得专属加速器地址，类似这样https://xxxxxx.mirror.aliyuncs.com

配置Docker加速器  -请把xxxx该为你的 加速器id

您可以使用如下的脚本将mirror的配置添加到docker daemon的启动参数中。

***系统要求 CentOS 7 以上，Docker 1.9 以上。***
``` bash 
sudo cp -n /lib/systemd/system/docker.service /etc/systemd/system/docker.service

sudo sed -i "s|ExecStart=/usr/bin/docker daemon|ExecStart=/usr/bin/docker daemon --registry-mirror=https://xxxxxx.mirror.aliyuncs.com|g" /etc/systemd/system/docker.service 
sudo systemctl daemon-reload 
sudo service docker restart
```

修改后的
/etc/systemd/system/docker.service
如下：

```
ExecStart=/usr/bin/docker daemon --registry-mirror=https://XXXX.mirror.aliyuncs.com \
          --exec-opt native.cgroupdriver=systemd \
          $OPTIONS \
          $DOCKER_STORAGE_OPTIONS \
          $DOCKER_NETWORK_OPTIONS \
          $INSECURE_REGISTRY
```

## 克隆项目

git clone https://github.com/deviantony/docker-elk.git

##  启动
cd docker-elk

docker-compose up

如果上面报错 请尝试下面
docker-compose up --build


放到后台 执行
docker-compose up -d

导入日志：
nc localhost 5000 < /path/to/logfile.log

    - sense：
    http://localhost:5601/app/sense
    默认端口
    - 5000: Logstash TCP input.
    - 9200: Elasticsearch HTTP
    - 9300: Elasticsearch TCP transport
    - 5601: Kibana


# 进入docker中
``` bash
$ sudo docker ps  
sudo docker exec -it 775c7c9ee1e1 /bin/bash 
```

# 更换软件源

***因为docker中的elk系统使用的是debian的***

更换为阿里mirror的软件源
``` bash
cat > /etc/apt/sources.list <<EOF
deb http://mirrors.aliyun.com/debian/ jessie main non-free contrib
deb http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ jessie main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ jessie-proposed-updates main non-free contrib
EOF

+ debian 简单软件包管理
    - apt-get clean && sudo apt-get autoclean  清理仓库
    - apt-get update 更新源
    - apt-cache search package 搜索包
    - apt-get install 安装


--------------------------------
+ 安装
docker pull sebp/elk

+ 运行
docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -p 5000:5000 -it --name elk sebp/elk

+ 配置
其实没什么配置，这里的 "配置"，只是往 logstash 中加入一条数据，从而可以进行后续的操作：

1
docker exec -it elk /bin/bash
执行

1
/opt/logstash/bin/logstash -e 'input { stdin { } } output { elasticsearch { hosts => ["localhost"] } }'
这个是将 logstash 的输出导到 ElasticSearch 中，而数据是从标准输入来的。

然后随便输入下东西，例如 "Hello World"，然后打开

1
http://<your-host>:5601
点击"创建"，即可进入下一步。

查看日志
ElasticSearch

1
http://vmubuntu.info:9200/_search?pretty
Kibana

1
http://vmubuntu.info:5601
添加日志
添加日志一般将日志导入到 logstash 中，而因为 logstash 在 docker 中，所以本地的话需要加一个日志收集器 filebeat。

安装 filebeat

1
2
curl -L -O https://download.elastic.co/beats/filebeat/filebeat_1.2.3_amd64.deb
sudo dpkg -i filebeat_1.2.3_amd64.deb
配置 filebeat

1
vim /etc/filebeat/filebeat.yml
在里面添加以下内容：

output:
      logstash:
        enabled: true
        hosts:
          - elk:5044
        tls:
          certificate_authorities:
            - /etc/pki/tls/certs/logstash-beats.crt
        timeout: 15

    filebeat:
      prospectors:
        -
          paths:
            - /var/log/syslog
            - /var/log/auth.log
          document_type: syslog
        -
          paths:
            - "/var/log/nginx/*.log"
          document_type: nginx-access
这样就可以了。然后启动 filebeat

1
service filebeat start
然后打开 kibana

设置图

首先要想添加一个 index，步骤如下：