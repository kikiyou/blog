让kubernate1.6 支持 etcd2

 i made sure to still use etcd v2, i passed the following to the kube-apiserver --storage-backend=etcd2 --storage-media-type=application/json, also the behavior is that the pods are restarting not deleted.


 ETCDCTL_API=3 etcdctl --endpoints ${all_endpoints} -w table endpoint status


 ETCDCTL_API=3 ./etcdctl migrate --data-dir=${data_dir} --transformer=${program_path}


ETCDCTL_API=3 etcdctl migrate

./etcdctl migrate --data-dir=/var/etcd --transformer=k8s-transformer
# finished transforming keys


先看下 etcd的leader 在那台主机
etcdctl member list

1. 备份etcd的中的数据


2. 让kubenates在 etcd v2 兼容模式下运行
$ kube-apiserver --storage-backend='etcd2' $(EXISTING_ARGS)



如果在升级到1.6之前已经升级到了etcd3，则在启动apiserver时需明确指定–storage-backend=etcd2 或 –storage-media-type=application/json；


kubelet实现Docker-CRI；
默认启用Docker-CRI；
新版kubelet与旧版kubelet创建的容器不兼容；


etcd 升级指南：
https://coreos.com/etcd/docs/latest/upgrades/upgrade_3_0.html



查看kubenates集群状态：
kubectl get cs

-------------------------------
etcd 2.3.7 升级到3.0.17

注：升级中遇到的坑
etcd不支持跨版本升级，etcd 2 直接升级到 etcd 3.2 会报错，需先升级到etcd 3.0

1. 升级前检查，确保所有节点集群状态是正常的

$ etcdctl cluster-health
$ curl http://localhost:2379/version
[root@k8s-node2 ~]# curl http://localhost:2379/version
{"etcdserver":"2.3.7","etcdcluster":"2.3.0"}[root@k8s-node2 ~]# 

2. 随便选择一台etcd节点，停止现存的etcd进程
（1） 停止
systemctl stop etcd
（2）备份数据：
$ etcdctl backup \
      --data-dir /opt/etcd/data/ \
      --backup-dir /tmp/etcd_backup

3. 使用v3版本的etcd文件替换老的
（1）替换etcd
mv /usr/bin/etcd /tmp/etcd_v2
curl -o /usr/bin/etcd  http://monkey.rhel.cc:8000/etcd_3/etcd
chmod 755  /usr/bin/etcd
（2）替换etcdctl
mv /usr/bin/etcdctl /usr/bin/etcdctl_v2
curl -o /usr/bin/etcdctl http://monkey.rhel.cc:8000/etcd_3/etcdctl
chmod 755  /usr/bin/etcdctl

（3）启动服务
systemctl start etcd

这时etcd日志中会显示：
7月 13 19:22:10 k8s-node1 etcd[32329]: updating the cluster version from 2.3 to 3.0
7月 13 19:22:10 k8s-node1 etcd[32329]: updated the cluster version from 2.3 to 3.0
7月 13 19:22:10 k8s-node1 etcd[32329]: enabled capabilities for version 3.0

+ 替换后进行状态检查
$ etcdctl cluster-health

curl http://localhost:2379/version
{"etcdserver":"3.0.17","etcdcluster":"2.3.0"}
注：所有节点没替换完全，会处于集群混合模式，etcdcluster依然以低版本运行
4. 重复 第二步和第三步  把所有节点都替换

5. 结束
所有节点替换完，查看当前etcdcluster集群版本
curl http://localhost:2379/version
{"etcdserver":"3.0.17","etcdcluster":"3.0.0"}



如果升级失败，还原办法：
echo y |cp -rp   /tmp/etcd_v2 /usr/bin/etcd 
echo y |cp -rp   /usr/bin/etcdctl_v2 /usr/bin/etcdctl

恢复备份：
mv /opt/etcd/data/default.etcd /opt/etcd/data/default.etcd_bak
cp -rp /tmp/etcd_backup /opt/etcd/data/default.etcd

chown -R etcd:etcd /opt/etcd/data/
chmod 755 /opt/etcd/data/ -R

etcd -data-dir=/opt/etcd/data/default.etcd  -force-new-cluster

[升级参考](https://coreos.com/etcd/docs/latest/upgrades/upgrade_3_0.html)
