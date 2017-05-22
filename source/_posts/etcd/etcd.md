##
etcd 下载：
http://onayasfq5.bkt.clouddn.com/etcd-v3.2.0-rc.1-linux-amd64.tar.gz


etcd启动：
./etcd

2017-05-20 14:40:56.139621 I | embed: listening for peers on http://localhost:2380
2017-05-20 14:40:56.140017 I | embed: listening for client requests on localhost:2379
2017-05-20 14:40:56.145280 I | etcdserver: name = default
2017-05-20 14:40:56.145334 I | etcdserver: data dir = default.etcd
2017-05-20 14:40:56.145358 I | etcdserver: member dir = default.etcd/member
2017-05-20 14:40:56.145377 I | etcdserver: heartbeat = 100ms
2017-05-20 14:40:56.145395 I | etcdserver: election = 1000ms
2017-05-20 14:40:56.145413 I | etcdserver: snapshot count = 100000
2017-05-20 14:40:56.145441 I | etcdserver: advertise client URLs = http://localhost:2379
2017-05-20 14:40:56.145462 I | etcdserver: initial advertise peer URLs = http://localhost:2380
2017-05-20 14:40:56.145499 I | etcdserver: initial cluster = default=http://localhost:2380

可以看到基本信息，比如默认创建的目录default.etcd


安装http客户端：
pip install --upgrade pip setuptools
pip install httpie


检查查询版本：
http http://127.0.0.1:2379/version



key的增删改查：

增和改
上面这个命令通过 PUT 方法把 /message 设置为 hello, etcd。
http PUT http://127.0.0.1:2379/v2/keys/message value=="hello, etcd"

查：
http get http://127.0.0.1:2379/v2/keys/message

删：
http DELETE http://127.0.0.1:2379/v2/keys/message