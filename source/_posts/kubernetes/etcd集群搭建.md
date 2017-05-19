yum 安装的 Etcd 默认配置文件在 /etc/etcd/etcd.conf，以下为 etcd0 上的样例(etcd1、etcd2同理)：

# 编辑配置文件
vim /etc/etcd/etcd.conf
# 样例配置如下

# 节点名称
ETCD_NAME=etcd0
# 数据存放位置
ETCD_DATA_DIR="/var/lib/etcd/etcd0"
# 监听其他 Etcd 实例的地址
ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
# 监听客户端地址
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379,http://0.0.0.0:4001"
# 通知其他 Etcd 实例地址
ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.1.154:2380"
# 初始化集群内节点地址
ETCD_INITIAL_CLUSTER="etcd0=http://192.168.1.154:2380,etcd1=http://192.168.1.156:2380,etcd2=http://192.168.1.249:2380"
# 初始化集群状态，new 表示新建
ETCD_INITIAL_CLUSTER_STATE="new"
# 初始化集群 token
ETCD_INITIAL_CLUSTER_TOKEN="mritd-etcd-cluster"
# 通知 客户端地址
ETCD_ADVERTISE_CLIENT_URLS="http://192.168.1.154:2379,http://192.168.1.154:4001"



systemctl  restart etcd && systemctl enabled etcd

查看排错：
journalctl -u etcd.service --since today

etcdctl cluster-health

etcdctl --debug member list

