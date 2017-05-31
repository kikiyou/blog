# etcd集群与etcd相关生态介绍 -- etcd能干什么

1.etcd集群
2.etcd-viewer -- etcd简单图形化界面
3.etcd与skydns集成 -- 基于dns的主机发现
4.etcd与confd的集成 -- 配置自动下发
5.etcd与ansible集成 -- ansible主机配置信息，从etcd获取


## etcd集群
etcd介绍 etcd是一个适用于分布式系统关键数据的 分布式可靠的 键-值存储数据库。

etcd  -->  /etc  + distributed

monkey1

./etcd --name monkey11 --initial-advertise-peer-urls http://172.16.6.43:3380 \
   --listen-peer-urls http://172.16.6.43:3380 \
   --listen-client-urls http://172.16.6.43:3379,http://127.0.0.1:3379 \
   --advertise-client-urls http://172.16.6.43:3379 \
   --initial-cluster-token etcd-cluster-1 \
   --initial-cluster monkey11=http://172.16.6.43:3380,monkey12=http://172.16.6.170:3380,monkey13=http://172.16.6.58:3380 \
   --initial-cluster-state new

monkey2

./etcd --name monkey12 --initial-advertise-peer-urls http://172.16.6.170:3380 \
   --listen-peer-urls http://172.16.6.170:3380 \
   --listen-client-urls http://172.16.6.170:3379,http://127.0.0.1:3379 \
   --advertise-client-urls http://172.16.6.170:3379 \
   --initial-cluster-token etcd-cluster-1 \
   --initial-cluster monkey11=http://172.16.6.43:3380,monkey12=http://172.16.6.170:3380,monkey13=http://172.16.6.58:3380 \
   --initial-cluster-state new


monkey3
./etcd --name monkey13 --initial-advertise-peer-urls http://172.16.6.58:3380 \
   --listen-peer-urls http://172.16.6.58:3380 \
   --listen-client-urls http://172.16.6.58:3379,http://127.0.0.1:3379 \
   --advertise-client-urls http://172.16.6.58:3379 \
   --initial-cluster-token etcd-cluster-1 \
   --initial-cluster monkey11=http://172.16.6.43:3380,monkey12=http://172.16.6.170:3380,monkey13=http://172.16.6.58:3380 \
   --initial-cluster-state new



export ETCDCTL_ENDPOINT=http://127.0.0.1:3379
./etcdctl member list

monkey1
./etcdctl set /opt/fonsview/3rd/tomcat/version 7.11

./etcdctl get /opt/fonsview/3rd/tomcat/version


在monkey2 上查询
export ETCDCTL_ENDPOINT=http://127.0.0.1:3379
./etcdctl get /opt/fonsview/3rd/tomcat/version


使用curl查询

设置：
curl -X PUT   http://172.16.6.43:3379/v2/keys/opt/fonsview/3rd/nginx/version -d "value=19.99"

查询：

curl   http://172.16.6.43:3379/v2/keys/opt/fonsview/3rd/nginx/version | python3 -m json.tool

## etcd-viewer
查看本机镜像:
docker images | grep  viewer

启动：
docker run -d -p 9999:8080 nikfoundas/etcd-viewer

访问：
http://monkey.rhel.cc:9999

添加远程etcd
monkey1
http://172.16.6.43:3379


monkey_remote
http://139.162.120.128:2379


## etcd与skydns集成

skydns 是个基于etcd的一个分布式 announcement（宣告）和 discovery（发现） 服务，它使用dns查询的方式来做服务发现。

DNS 有如下优点：
1. 域名见名知意并且方便记忆
2. 域名是持久的，但是ip是经常改变的（比如：当你把迁移一个服务到另一个主机）
3. 一个域名可以对应多个ip地址/主机 （负载均衡）
4. 一个ip地址（和服务）可以使用多个域名 - 节省主机费用,简化管理
5. 域名请求可以支持SSL/HTTPS 加密通信

域名可以支持 service-to-service and client-to-service 通信，负载均衡和零-停机时间 升级。


安装：
wget http://7xw819.com1.z0.glb.clouddn.com/skydns

1. 启动

初始化设置：
export ETCD_MACHINES='http://172.16.6.43:3379'
etcdctl set /skydns/config '{"dns_addr":"0.0.0.0:53","ttl":60,"domain": "fonsview.local.","nameservers": ["8.8.8.8:53","8.8.4.4:53"]}'

./skydns -verbose


2.  设置dns
vi /etc/resolv.conf
search fonsview.local
nameserver 172.16.6.43


3. 查询现在dns设置是否正确
root ➜  ~ nslookup www.baidu.com
Server:		172.16.6.43
Address:	172.16.6.43#53

Non-authoritative answer:
www.baidu.com	canonical name = www.a.shifen.com.
Name:	www.a.shifen.com
Address: 103.235.46.39


4. 设置自定义dns
export ETCDCTL_ENDPOINT=http://172.16.6.43:3379
etcdctl  set /skydns/local/fonsview/test1 '{"host":"172.16.12.41"}' 

etcdctl  set /skydns/local/fonsview/monkey1 '{"host":"172.16.6.43"}' 

5. 查询
nslookup test1


etcdctl  set /skydns/local/fonsview/service/1 '{"host":"172.16.6.43"}'
etcdctl  set /skydns/local/fonsview/service/2 '{"host":"172.16.6.170"}'
etcdctl  set /skydns/local/fonsview/service/3 '{"host":"172.16.6.58"}'


## etcd与confd的集成
1. 下载

wget http://7xw819.com1.z0.glb.clouddn.com/confd-0.11.0-linux-amd64

chmod +x confd-0.11.0-linux-amd64


2. 建立初始化目录
sudo mkdir -p /etc/confd/{conf.d,templates}


/etc/confd/conf.d/myconfig.toml
[template]
src = "myconfig.conf.tmpl"
dest = "/tmp/myconfig.conf"
keys = [
    "/myapp/database/url",
    "/myapp/database/user",
]


/etc/confd/templates/myconfig.conf.tmpl
[myconfig]
database_url = {{getv "/myapp/database/url"}}
database_user = {{getv "/myapp/database/user"}}




etcdctl set /myapp/database/url db.example.com
etcdctl set /myapp/database/user rob


./confd-0.11.0-linux-amd64 -onetime=false -interval=1 -backend etcd -node http://172.16.6.43:3379


## etcd与ansible集成

export ETCD_INI_PATH=/home/monkey/sync/monkey-ott-cdn/etcd.ini


etcdctl  set /ansible/groupvars/zabbix/foo v2 
etcdctl  set /ansible/hostvars/OTT-NA-EPG1/ansible_host 127.0.0.1
etcdctl  set /ansible/hostvars/OTT-NA-EPG1/group_name  "海林"
etcdctl  set /ansible/hostvars/OTT-NA-EPG1/ansible_user monkey
etcdctl  set /ansible/hostvars/OTT-NA-EPG1/ansible_ssh_pass "redhat"
etcdctl  set /ansible/hostvars/OTT-NA-EPG1/ansible_port 22
etcdctl  set /ansible/hostvars/OTT-NA-EPG1/ansible_become_pass "redhat"
etcdctl  set /ansible/hosts/zabbix/OTT-NA-EPG1 11


使用 列出变量
python etcd_hosts.py --host OTT-NA-EPG1


ansible -i etcd_hosts.py all -m shell  -a "echo group_name = {{  group_name }}"