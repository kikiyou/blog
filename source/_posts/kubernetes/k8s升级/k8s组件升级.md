k8s 1.5.1 -> 1.6.7 

组件:
node：
kubelet  
kube-proxy

master：
kube-apiserver
kube-controller-manager
kube-scheduler
kube-proxy

依赖文件，远程仓库快速搭建：
路径：
it-fs/Upload/开放式架构版本/k8s_update_1.6.7.tar.xz

1. tar xf k8s_update_1.6.7.tar.xz
2. cd k8s_update
3. python -m SimpleHTTPServer

如上步骤，可以快速搭建一个基于http的远程仓库,下面部署中需要的文件，均从这里下载。


*** 升级前，请先看版本发布文档，细看官方changelog，版本之间的变化请关注，尤其是api接口的变化 ***

一、升级前检查
1. 查看各个主机都安装了哪些主机
ps aux | grep kube-

2. 查看各个组件是怎么部署的
（1） 使用kubeadm ？
（2） 使用二进制部署 ？

二、升级步骤

+ 升级node

1. 把要升级node上的pod全部迁走

 $ kubectl drain --force node-4 --ignore-daemonsets 

 $ kubectl get nodes
  NAME      STATUS                     AGE
  node-4     Ready,SchedulingDisabled   36d

如上 可以看到，node-4 主机已经是SchedulingDisabled状态

 $ kubectl  get pod --all-namespaces=true -o wide | grep node-4

检查所有pod是否已经全部被迁移

2. 升级kube-proxy
注：由于 kube-proxy是由 kubeadm部署，以pod的方式运行在主机，具体为升级kube-proxy的pod

	1. 导入 kube-proxy镜像

	curl -o /tmp/kube-proxy.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-proxy.tar
	docker load < /tmp/kube-proxy.tar

	docker tag gcr.io/google_containers/kube-proxy:e9033cca62c22462e4d265809247d752 gcr.io/google_containers/kube-proxy:v1.6.7

	2. 查看镜像：
	docker images | grep kube-proxy:v1.6.7

	3. 修改镜像版本
	kubectl edit ds/kube-proxy -n kube-system
	daemonset "kube-proxy" edited

3. 升级kubelet与kubectl
停止：
systemctl  stop kubelet

备份：
mv /usr/bin/kubelet /tmp/kubelet_1.5
mv /usr/bin/kubectl /tmp/kubectl_1.5

升级替换：
curl -o /usr/bin/kubelet http://monkey.rhel.cc:8000/k8s_1_6/kubelet
chmod 755  /usr/bin/kubelet

curl -o /usr/bin/kubectl http://monkey.rhel.cc:8000/k8s_1_6/kubectl
chmod 755  /usr/bin/kubectl

启动：
systemctl  start kubelet

检查更新后版本：
kubelet --version
kubectl version
systemctl status kubelet

4. 恢复主机调度
 $ kubectl uncordon node-4 
 $ kubectl get nodes
 $ kubectl get pod --all-namespaces=true -o wide | grep node-4

在所有node主机上，重复上面操作
二、升级master节点
注： 由于 master是由kubeadm部署，如下组件是由pod的形式存在
kube-apiserver
kube-controller-manager
kube-scheduler
kube-proxy

注： 由于1.5.1 升级 1.6.7 ，存在etcd数据库由v2模式转换成v3模式，所以需要停止kube-apiserver 保证备份数据完整
注： 为升级简单，和数据一致性保证，迁移etcd数据时直接停止了dcoker，以后升级可以不停止docker

1. 提前导入镜像 （master节点）
导入：
curl -o /tmp/kube-scheduler.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-scheduler.tar
docker load < /tmp/kube-scheduler.tar

curl -o /tmp/kube-apiserver.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-apiserver.tar
docker load < /tmp/kube-apiserver.tar

curl -o /tmp/kube-controller-manager.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-controller-manager.tar
docker load < /tmp/kube-controller-manager.tar

curl -o /tmp/kube-proxy.tar http://monkey.rhel.cc:8000/k8s_1_6/kube-proxy.tar
docker load < /tmp/kube-proxy.tar



修改tag：
docker tag gcr.io/google_containers/kube-scheduler:d0b09c97b763b940e4f6237bced5ec7d gcr.io/google_containers/kube-scheduler:v1.6.7

docker tag gcr.io/google_containers/kube-apiserver:0c91d6b7096af6d8c880c4502b8f945a gcr.io/google_containers/kube-apiserver:v1.6.7

docker tag gcr.io/google_containers/kube-controller-manager:2f24e64882bbd076fe023b64c621f595 gcr.io/google_containers/kube-controller-manager:v1.6.7

docker tag gcr.io/google_containers/kube-proxy:e9033cca62c22462e4d265809247d752 gcr.io/google_containers/kube-proxy:v1.6.7

1. 记录下当前api-versions 
kubectl api-versions > /tmp/old_api-versions.txt

2. 如果master节点存在业务pod，请把master设置为不可调度
 $ kubectl drain --force master-4 --ignore-daemonsets 

3. etcd数据迁移：
	1. 停止 kubelet 与 docker （master节点）

	 systemctl stop kubelet
	 systemctl stop docker
	2. 各个etcd节点，停止etcd
	 systemctl stop etcd

	3. 各个etcd节点，备份数据
	$ etcdctl backup \
	      --data-dir /opt/etcd/data/ \
	      --backup-dir /tmp/etcd_backup2

	4. 各个etcd节点，v2到v3的数据迁移
	wget http://monkey.rhel.cc:8000/etcd-v3.2.2-linux-amd64/etcdctl
	chmod 755 ./etcdctl
	ETCDCTL_API=3 ./etcdctl migrat --data-dir=/opt/etcd/data/

	5. 各个etcd节点，启动etcd
	 systemctl start etcd

	6. 检查etcd状态,v3中是否有数据：
	ETCDCTL_API=3 etcdctl member list

	ETCDCTL_API=3 etcdctl get --prefix=true ""
 	
	7. 重启 kubelet 与 docker （master节点）

	 systemctl start kubelet
	 systemctl start docker

4. 修改pod的镜像版本,使用上面导入的最新镜像
注： 由于kubeadm 是用daemonsets的静态pod方式部署，要修改文件

vi /etc/kubernetes/manifests/kube-apiserver.json
vi /etc/kubernetes/manifests/kube-controller-manager.json
vi /etc/kubernetes/manifests/kube-scheduler.json

4. 查看是否生效
先查看pod名：
kubectl get pods -n kube-system

查看具体pod的镜像：
kubectl get pod/kube-apiserver-k8s-master -o yaml -n kube-system | grep image
kubectl get pod/kube-scheduler-k8s-master  -o yaml -n kube-system | grep image
kubectl get pod/kube-controller-manager-k8s-master -o yaml -n kube-system | grep image

注：如果pod的镜像修改没有生效，需要重启kubelet

5. 重启calico网络 (calico每个节点)
systemctl  restart calico

6. 检查与排错
升级后最后看一下，那些容器状态是不正常的
kubectl  get pods --all-namespaces=true | grep -v Running

查看api-server和kube-controller、scheduler的log，看是否有异常报错

1. 查看当前api-version
kubectl api-versions > /tmp/new_api-versions.txt

对比升级前和升级后api-versions的异同
diff /tmp/old_api-versions.txt /tmp/new_api-versions.txt

注：由于升级api-server 可能会有不同版本api-server提供的api接口不同，导致k8s异常，请关注相关报错


下面是可能用到的知识点：
[k8s升级参考文档](https://dzone.com/articles/upgrading-kubernetes-on-bare-metal-coreos-cluster-1)

dashboard 升级：
导入新版
curl -o /tmp/kubernetes-dashboard-amd64_v1.6.1.tar http://monkey.rhel.cc:8000/k8s_1_6/kubernetes-dashboard-amd64_v1.6.1.tar
docker load < /tmp/kubernetes-dashboard-amd64_v1.6.1.tar

修改dashboard的deploy中的镜像
kubectl edit deploy/kubernetes-dashboard -n kube-system

注：如果etcd 不想从v2 转换为v3，api server可以在启动时添加如下参数，使用兼容模式运行
apiserver使用兼容模式运行：
$ kube-apiserver --storage-backend='etcd2' --storage-media-type=application/json $(EXISTING_ARGS)


kubeadm升级:
mv /usr/bin/kubeadm /tmp/kubeadm_1.5
curl -o /usr/bin/kubeadm http://monkey.rhel.cc:8000/k8s_1_6/kubeadm
chmod 755  /usr/bin/kubeadm
/usr/bin/kubeadm version


查看由多个 container组成的容器时，使用-c 指定container
[root@node-4 ~]# kubectl logs kube-dns-927355630-1pzv4  -n kube-system -c kube-dns


排错一例子如下：

升级前：
[root@master ~]# kubectl api-versions
apps/v1beta1
authentication.k8s.io/v1beta1
authorization.k8s.io/v1beta1
autoscaling/v1
batch/v1
certificates.k8s.io/v1alpha1
extensions/v1beta1
policy/v1beta1
rbac.authorization.k8s.io/v1alpha1
storage.k8s.io/v1beta1
v1


升级后：
[root@k8s-master manifests]# kubectl api-versions
apps/v1beta1
authentication.k8s.io/v1
authentication.k8s.io/v1beta1
authorization.k8s.io/v1
authorization.k8s.io/v1beta1
autoscaling/v1
batch/v1
certificates.k8s.io/v1beta1
extensions/v1beta1
policy/v1beta1
rbac.authorization.k8s.io/v1alpha1
rbac.authorization.k8s.io/v1beta1
settings.k8s.io/v1alpha1
storage.k8s.io/v1
storage.k8s.io/v1beta1
v1

通过对比api-versions 在v1.6中，certificates.k8s.io/v1alpha1接口被删除

查看 apiserver的log中：
kubectl logs kube-apiserver-k8s-master -n kube-system -f
报错：
E0721 07:57:01.680037       1 cacher.go:274] unexpected ListAndWatch error: k8s.io/kubernetes/vendor/k8s.io/apiserver/pkg/storage/cacher.go:215: Failed to list *certificates.CertificateSigningRequest: no kind "CertificateSigningRequest" is registered for version "certificates.k8s.io/v1alpha1"


原因：
certificates.k8s.io/v1alpha1 接口在1.6中被删除，在1.6中被命名为：certificates.k8s.io/v1beta1

标准做法：
  请参考这里：
  在1.5中删除认证，再1.6中重新添加认证
  https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/



非标准:
但证实的办法，直接修改etcd中的字段,把certificates.k8s.io中的 v1alpha1 替换为 v1beta1

修改技巧：
[root@k8s-master manifests]# export ETCDCTL_API=3
[root@k8s-master manifests]# etcdctl get --prefix=true "" | grep certificates
[root@k8s-master manifests]# ETCDCTL_API=3 etcdctl get --prefix=true "" | grep certificates

[root@k8s-master manifests]# cat csr-z2g50  | etcdctl put /registry/certificatesigningrequests/csr-z2g50


修改好后：
kubectl logs kube-controller-manager-k8s-node2 -n kube-system -f

kube-controller-manager 日志如下，说明问题已经处理：

E0721 07:56:54.540403       1 reflector.go:201] k8s.io/kubernetes/pkg/client/informers/informers_generated/externalversions/factory.go:70: Failed to list *v1beta1.CertificateSigningRequest: the server cannot complete the requested operation at this time, try again later (get certificatesigningrequests.certificates.k8s.io)
I0721 07:57:03.410328       1 garbagecollector.go:116] Garbage Collector: All resource monitors have synced. Proceeding to collect garbage
W0721 08:08:18.345870       1 reflector.go:323] k8s.io/kubernetes/pkg/controller/garbagecollector/graph_builder.go:192: watch of <nil> ended with: etcdserver: mvcc: required revision has been compacted