主机信息：
k8s环境升级
172.16.6.85
172.16.6.42

root/hello123

------------------
注：运行过加固脚本的，请先执行解除加固的脚本

1. 查看自己当前主机的ip
ip a

2. 查看pod都在那台主机
kubectl get pods -o wide

简单查看各个主机中容器的数量
[root@k8s-master ~]# kubectl get pods  -o wide | grep node1 |wc -l
9
[root@k8s-master ~]# kubectl get pods  -o wide | grep node2 |wc -l
24
[root@k8s-master ~]# kubectl get pods  -o wide | grep master |wc -l
5


删除node
kubectl delete node xxx

unschedule_node.yaml

apiVersion: v1
kind: Node
metadata:
  name: k8s-node1
  labels:
    kubernetes.io/hostname: k8s-node1
spec:
  unschedulable: true

kubectl replace -f unschedule_node.yaml
查看Node的状态，可以观察到在Node的状态中增加了一项SchedulingDisabled：

$ kubectl get nodes
NAME                 LABELS                                      STATUS
kubernetes-minion1   kubernetes.io/hostname=kubernetes-minion1   Ready, SchedulingDisabled
对于后续创建的Pod，系统将不会再向该Node进行调度。

升级前把容器迁移到别的主机，
我现在要把node1中的主机都迁移走
ReplicationController
在xx-controller.yaml 中
    spec:
      serviceAccountName: elasticsearch
      nodeName: k8s-master
      containers:
增加nodeName: node2

把主机迁到node1中
kubectl edit svc/apigw

3. 升级容器
1. 查看当前容器版本：
docker version | grep "Version"
2. 停止当前docker
systemctl stop docker

检查是否真正停止了
ps aux | grep docker

3.

mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/


升级

cat << "_EOF" > /etc/yum.repos.d/docker-main.repo
[docker-main-repo]
name=Docker main Repository
baseurl=http://monkey.rhel.cc:8000/docker_17/7/
enabled=1
gpgcheck=0
_EOF

yum install docker-engine -y

4. 启动服务：
systemctl  start docker

6. 查看当前版本
docker version | grep "Version"

7. 查看各个pod是否工作正常
kubectl get pods -o wide

如果都是Running说明正常


参考：
https://tachingchen.com/tw/blog/Kubernetes-Assigning-Pod-to-Nodes/

查询现有标签：
kubectl get nodes --show-labels

1. 新增标签
kubectl label node k8s-master networkSpeed=high
kubectl label node k8s-node2 networkSpeed=high
kubectl label node k8s-node1 networkSpeed=low

2. 删除标签
You can remove incorrect label with <label>-

$ kubectl label node 192.168.1.1 networkSpeed-


3. 编辑DEPLOYMENT
增加：
      nodeSelector:
        networkSpeed: "high"


kubectl edit po/apigw-2061214945-zhw6f


kubectl get pods -o wide | grep node1 | grep MatchNodeSelector|awk ' { print $1}' >1.txt

for i in $(cat 1.txt) ;  do  kubectl delete pod ${i} ; done



遇到报错处理：
7月 12 14:53:55 hawaii dockerd[39497]: Error starting daemon: error initializing graphdriver: devmapper: Base Device UUID and Filesystem verification failed: devicemapper: Error running deviceCreate (ActivateDevice) dm_task_run failed



处理办法：
$ rm -rf /var/lib/docker/devicemapper
$ systemctl start docker