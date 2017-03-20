推荐方案
Consul + confd
或
Consul + Consul template


https://github.com/ansible/ansible/blob/devel/contrib/inventory/consul_io.py
## 参考
[服务发现：Zookeeper vs etcd vs Consul](http://dockone.io/article/667)

[关于配置的思考](http://www.zenlife.tk/%E5%85%B3%E4%BA%8E%E9%85%8D%E7%BD%AE%E7%9A%84%E6%80%9D%E8%80%83.md)
=======
## consul的使用

Consultemplate
EnvConsul


## 安装
wget https://releases.hashicorp.com/consul/0.7.2/consul_0.7.2_linux_amd64.zip
unzip  consul_0.7.2_linux_amd64.zip

sudo cp '/home/yh/Downloads/consul'  /usr/bin/consul

下载 webUI
https://releases.hashicorp.com/consul/0.7.2/consul_0.7.2_web_ui.zip


+ 启动客户端
consul agent -dev

curl localhost:8500/v1/catalog/nodes

[
    {
        "Node": "fedora.rhel.cc",
        "Address": "127.0.0.1",
        "TaggedAddresses": {
            "lan": "127.0.0.1",
            "wan": "127.0.0.1"
        },
        "CreateIndex": 4,
        "ModifyIndex": 5
    }
]


dig @127.0.0.1 -p 8600 fedora.rhel.cc


## 启动server
sudo mkdir /etc/consul.d
echo '{"service": {"name": "web", "tags": ["rails"], "port": 80}}' \
    | sudo tee /etc/consul.d/web.json


consul agent -dev -config-dir=/etc/consul.d


dig @127.0.0.1 -p 8600 web.service.consul SRV
dig @127.0.0.1 -p 8600 rails.web.service.consul


curl http://localhost:8500/v1/catalog/service/web
[
    {
        "Node": "fedora.rhel.cc",
        "Address": "127.0.0.1",
        "TaggedAddresses": {
            "lan": "127.0.0.1",
            "wan": "127.0.0.1"
        },
        "ServiceID": "web",
        "ServiceName": "web",
        "ServiceTags": [
            "rails"
        ],
        "ServiceAddress": "",
        "ServicePort": 80,
        "ServiceEnableTagOverride": false,
        "CreateIndex": 6,
        "ModifyIndex": 6
    }
]


curl 'http://localhost:8500/v1/health/service/web?passing'



## 启动web-ui

consul agent -server -bootstrap-expect 1 -data-dir /tmp/consul -ui-dir=./  -config-dir /etc/consul.d

##查看信息
consul info

[Consul 搭建服务框架（使用篇）](http://dockone.io/article/1565)
[Docker结合Consul实现的服务发现（二）参考](http://dockone.io/article/1360)

https://github.com/jippi/hashi-ui
nomad
