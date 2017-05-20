# fedora 安装单节点环境
dnf download kubernetes-master   --destdir ./k8s

设定时间区
timedatectl set-timezone Asia/Shanghai

1. 安装
dnf install kubernetes docker

会安装以下软件包
conntrack-tools 
container-selinux 
docker 
docker-common 
iptables 
kubernetes 
kubernetes-client 
kubernetes-master 
kubernetes-node 
libnetfilter_conntrack 
libnetfilter_cthelper 
libnetfilter_cttimeout 
libnetfilter_queue 
libnfnetlink 
socat 


2. 安装etcd
dnf -y install etcd

3. 自定义dns
echo "172.16.6.58    fed-master
172.16.199.224 fed-node" >> /etc/hosts

4. 编辑/etc/kubernetes/config 指定master是哪个（每台主机都要修改）
sed -i '/KUBE_MASTER/s/127.0.0.1:8080/fed-master:8080/g'  /etc/kubernetes/config

grep KUBE_MASTER /etc/kubernetes/config

5. 关闭防火墙
systemctl disable iptables-services firewalld
systemctl stop iptables-services firewalld


6. 在master主机上编辑 

(1) /etc/kubernetes/apiserver

sed -i '/KUBE_API_ADDRESS/s/127.0.0.1/0.0.0.0/g'  /etc/kubernetes/apiserver
grep KUBE_API_ADDRESS /etc/kubernetes/apiserver


(2) /etc/etcd/etcd.conf 设置etd侦听所有网络，如果你不设置 你可能会收到“connection refused”这样的错误

sed -i '/ETCD_LISTEN_CLIENT_URLS/s/localhost:2379/0.0.0.0:2379/g' /etc/etcd/etcd.conf
grep -v '#' /etc/etcd/etcd.conf

5. 在master上启动 如下服务
for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler; do
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES
done

6. 如下命令 添加节点：

{
    "apiVersion": "v1",
    "kind": "Node",
    "metadata": {
        "name": "fed-node",
        "labels":{ "name": "fed-node-label"}
    },
    "spec": {
        "externalID": "fed-node"
    }
}

$ kubectl create -f ./node.json

$ kubectl get nodes
NAME            STATUS        AGE
fed-node        Unknown       4h

编辑/etc/kubernetes/config
sed -i '/KUBELET_ADDRESS/s/--address=127.0.0.1/--address=0.0.0.0/g'  /etc/kubernetes/kubelet
sed -i '/KUBELET_HOSTNAME/s/127.0.0.1/fed-node/g'  /etc/kubernetes/kubelet
sed -i '/KUBELET_API_SERVER/s/127.0.0.1:8080/fed-master:8080/g'  /etc/kubernetes/kubelet


在node节点上启动服务
for SERVICES in kube-proxy kubelet docker; do 
    systemctl restart $SERVICES
    systemctl enable $SERVICES
    systemctl status $SERVICES 
done

配置正常的话在minion主机可以看到：
[root@monkey2 ~]# kubectl version
Client Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.3", GitCommit:"029c3a408176b55c30846f0faedf56aae5992e9b", GitTreeState:"clean", BuildDate:"2017-03-09T11:55:06Z", GoVersion:"go1.7.5", Compiler:"gc", Platform:"linux/amd64"}
Server Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.3", GitCommit:"029c3a408176b55c30846f0faedf56aae5992e9b", GitTreeState:"clean", BuildDate:"2017-03-09T11:55:06Z", GoVersion:"go1.7.5", Compiler:"gc", Platform:"linux/amd64"}






报错处理：
[root@monkey2 kubernetes]# kubectl version
Client Version: version.Info{Major:"1", Minor:"5", GitVersion:"v1.5.3", GitCommit:"029c3a408176b55c30846f0faedf56aae5992e9b", GitTreeState:"clean", BuildDate:"2017-03-09T11:55:06Z", GoVersion:"go1.7.5", Compiler:"gc", Platform:"linux/amd64"}
The connection to the server localhost:8080 was refused - did you specify the right host or port?


可以指定api-server的ip
kubectl -s http://apiserverIP:8080 version


alias kubectl=" kubectl -s http://fed-master:8080"


dashboard安装

镜像地址：
https://hub.docker.com/u/googlecontainer/

#下载dashboard 配置
curl -o kubernetes-dashboard.yaml https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard-no-rbac.yaml

kubectl create -f kubernetes-dashboard.yaml

kubectl get -f kubernetes-dashboard.yaml

1.6.1 镜像下载地址：


vi kubernetes-dashboard.yaml
配置使用本地镜像源和apiserver地址
- --apiserver-host=http://fed-master:8080


查看k8s的命令
kubectl get deployment kubernetes-dashboard --namespace=kube-system
kubectl get svc kubernetes-dashboard --namespace=kube-system

排错：
kubectl get events --namespace=kube-system
可以查看到 有哪些容器

kubectl --namespace=kube-system logs kubernetes-dashboard-911386560
kubectl  get pod  --all-namespaces -o wide
kubectl  get service  --all-namespaces

[root@monkey1 conf]# kubectl get pod  --namespace=kube-system
NAME                                    READY     STATUS              RESTARTS   AGE
kubernetes-dashboard-2692392454-ps3ks   0/1       ContainerCreating   0          5m


kubectl describe pod kubernetes-dashboard-2692392454-ps3ks  --namespace=kube-system

docker load < /tmp/kubernetes-dashboard-amd64_v1.6.1.tar.gz
docker load < pause-amd64_3.0.tar