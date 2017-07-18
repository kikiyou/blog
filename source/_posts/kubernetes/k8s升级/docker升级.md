docker 1.12.6 升级17.05.0-ce
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

3. 升级前把容器迁移到别的主机，

示例:把node1 上的pod迁移到node2

方法一：
(1). 找到node1 主机上pod使用的deployments
[root@k8s-master ~]#kubectl get deployments
(2). 查看pod分布
[root@k8s-master ~]# kubectl get pods -o wide | grep desktop
desktop-4081196079-cqvkt            1/1       Running   0          1m        192.168.36.178    k8s-node1
desktop-4081196079-xm9rp            1/1       Running   0          1m        192.168.36.171    k8s-node1


(3). 修改deployments 绑定到节点k8s-node2
[root@k8s-master ~]# kubectl edit deploy/desktop
deployment "desktop" edited

编辑时加入： nodeName: k8s-node2
具体插入位置如下：
    spec:
      nodeName: k8s-node2
      containers:

(4). 查看修改后分布
[root@k8s-master ~]# kubectl get pods -o wide | grep desktop
desktop-4105444400-22mpk            1/1       Running   0          1m        192.168.169.216   k8s-node2
desktop-4105444400-zt8jh            1/1       Running   0          1m        192.168.169.217   k8s-node2

如上可以看到 pod desktop 已经迁移到 k8s-node2 主机上

方法二： 使用标签选择器
(1). 查询现有标签：
kubectl get nodes --show-labels

(2). 新增标签
kubectl label node k8s-master networkSpeed=high
kubectl label node k8s-node2 networkSpeed=high
kubectl label node k8s-node1 networkSpeed=low

(3). 删除标签
You can remove incorrect label with <label>-

$ kubectl label node 192.168.1.1 networkSpeed-


(4). 编辑DEPLOYMENT

(5). 查询现有deployments
kubectl get deployments
kubectl edit deploy/
增加：
      nodeSelector:
        networkSpeed: "high"


4. 升级容器
(1). 查看当前容器版本：
docker version | grep "Version"
(2). 停止当前docker
systemctl stop docker

检查是否真正停止了
ps aux | grep docker

(3).修改升级yum源

mkdir -p /etc/yum.repos.d/bak
mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/bak/

创建升级yum仓库

cat << "_EOF" > /etc/yum.repos.d/docker-main.repo
[docker-main-repo]
name=Docker main Repository
baseurl=http://monkey.rhel.cc:8000/docker_17/7/
enabled=1
gpgcheck=0
_EOF

yum install docker-engine -y

5. 启动服务：
systemctl  start docker

6. 查看当前版本
docker version | grep "Version"
 Version:      17.05.0-ce
 Version:      17.05.0-ce

7. 查看各个pod是否工作正常
kubectl get pods -o wide

如果都是Running说明正常

如果标签选择器出错，创建大量状态为MatchNodeSelector的pod，可使用如下命令批量删除
kubectl get pods -o wide | grep node1 | grep MatchNodeSelector|awk ' { print $1}' >1.txt
for i in $(cat 1.txt) ;  do  kubectl delete pod ${i} ; done


遇到报错处理：
7月 12 14:53:55 hawaii dockerd[39497]: Error starting daemon: error initializing graphdriver: devmapper: Base Device UUID and Filesystem verification failed: devicemapper: Error running deviceCreate (ActivateDevice) dm_task_run failed

处理办法：
$ rm -rf /var/lib/docker/devicemapper
$ systemctl start docker


标签选择器参考：
https://tachingchen.com/tw/blog/Kubernetes-Assigning-Pod-to-Nodes/