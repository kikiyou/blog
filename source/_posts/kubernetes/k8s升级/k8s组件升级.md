主机信息：
k8s环境升级
172.16.6.85
172.16.6.42

root/hello123

------------------

k8s 组件:
kubelet  
kube-proxy

kube-proxy
kube-apiserver
kube-controller-manager
kube-scheduler
policy-controller


apiserver使用兼容模式运行：
$ kube-apiserver --storage-backend='etcd2' $(EXISTING_ARGS)

1. 迁移走这个节点的所有pod
把这个节点设置成不可调度，并转移这个节点的所有pod
 $ kubectl drain --force my_node_name 

查看pod是否已经迁移走
 $ kubectl get nodes 

 这个节点会被设置成 Ready,SchedulingDisabled

 这时停止：
 systemctl stop kubelet

 systemctl stop docker


 验证：
 $ ps aux | grep kube
 $ kubectl get nodes  

 $ wget https://github.com/coreos/etcd/releases/download/v3.2.0/etcd-v3.2.0-linux-amd64.tar.gz


 迁移etcd的数据
  $ ETCDCTL_API=3 ./etcdctl migrat --data-dir=/var/lib/etcd 


启动节点调用
 $ kubectl uncordon my_node_name 


[k8s升级参考文档](https://dzone.com/articles/upgrading-kubernetes-on-bare-metal-coreos-cluster-1)


------------------tom--环境升级
ps aux | grep kube-

升级步骤：

升级节点：
1. 把节点上的pod全部迁移走
 $ kubectl drain --force tom-4 --ignore-daemonsets 

[root@tom-3 ~]# kubectl get nodes
NAME      STATUS                     AGE
tom-3     Ready,master               39d
tom-4     Ready,SchedulingDisabled   36d


2. 查看节点有那些组件
ps aux | grep kube

kubectl version
Client Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.1", GitCommit:"82450d03cb057bab0950214ef122b67c83fb11df", GitTreeState:"clean", BuildDate:"2016-12-14T00:57:05Z", GoVersion:"go1.7.4", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.1", GitCommit:"82450d03cb057bab0950214ef122b67c83fb11df", GitTreeState:"clean", BuildDate:"2016-12-14T00:52:01Z", GoVersion:"go1.7.4", Compiler:"gc", Platform:"linux/amd64"}


Upload Success,url:
          http://7xw819.com1.z0.glb.clouddn.com/kubernetes-server-linux-amd64_v1.6.7.tar.gz

1. 升级 kubelet kubectl kube-proxy
停止 systemctl  stop kubelet


备份
mv /usr/bin/kubelet /tmp/kubelet_1.5
curl -o /usr/bin/kubelet http://monkey.rhel.cc:8000/k8s_1_6/kubelet
chmod 755  /usr/bin/kubelet


mv /usr/bin/kubectl /tmp/kubectl_1.5
curl -o /usr/bin/kubectl http://monkey.rhel.cc:8000/k8s_1_6/kubectl
chmod 755  /usr/bin/kubectl


导入 kube-proxy镜像
curl -o /tmp/kube-proxy.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-proxy.tar
docker load < /tmp/kube-proxy.tar


systemctl  start kubelet.service

查看更新后版本
[root@tom-4 ~]# kubelet --version
Kubernetes v1.6.7

kubectl version


[root@tom-3 ~]# docker load < /tmp/kube-proxy.tar
e621494a2487: Loading layer [==================================================>]  42.05MB/42.05MB
25ffec147d27: Loading layer [==================================================>]  4.744MB/4.744MB
d7aca1b11cbe: Loading layer [==================================================>]  64.02MB/64.02MB
Loaded image: gcr.io/google_containers/kube-proxy:e9033cca62c22462e4d265809247d752
[root@tom-3 ~]# 
[root@tom-3 ~]# kubectl edit ds/kube-proxy -n kube-system
daemonset "kube-proxy" edited
[root@tom-3 ~]# kubectl get pods -n 


 $ kubectl uncordon tom-4 

删除节点
kubectl delete node xxx

[root@tom-3 ~]# etcdctl ls /registry/minions
/registry/minions/tom-4.novalocal
/registry/minions/tom-3.novalocal
/registry/minions/tom-3
/registry/minions/tom-4
[root@tom-3 ~]# kubectl get nodes
NAME              STATUS            AGE       VERSION
tom-3             NotReady,master   40d       v1.5.1
tom-3.novalocal   Ready             12m       v1.6.7
tom-4             NotReady          36d       v1.5.1
tom-4.novalocal   Ready             2h        v1.6.7



kube-scheduler
kube-apiserver
kube-controller-manager



导入 kube-proxy镜像
curl -o /tmp/kube-scheduler.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-scheduler.tar
docker load < /tmp/kube-scheduler.tar

curl -o /tmp/kube-apiserver.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-apiserver.tar
docker load < /tmp/kube-apiserver.tar

curl -o /tmp/kube-controller-manager.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-controller-manager.tar
docker load < /tmp/kube-controller-manager.tar

docker tag gcr.io/google_containers/kube-scheduler:d0b09c97b763b940e4f6237bced5ec7d gcr.io/google_containers/kube-scheduler:v1.6.7

docker tag gcr.io/google_containers/kube-apiserver:0c91d6b7096af6d8c880c4502b8f945a gcr.io/google_containers/kube-apiserver:v1.6.7

docker tag gcr.io/google_containers/kube-controller-manager:2f24e64882bbd076fe023b64c621f595 gcr.io/google_containers/kube-controller-manager:v1.6.7



kubectl edit pod/kube-scheduler -n kube-system

kubectl edit pod/kube-apiserver -n kube-system

kubectl edit pod/kube-controller-manager -n kube-system


--storage-type=etcd2 --storage-media-type=application/json