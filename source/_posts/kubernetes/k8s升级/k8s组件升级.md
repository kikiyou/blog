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
docker tag gcr.io/google_containers/kube-proxy:e9033cca62c22462e4d265809247d752 gcr.io/google_containers/kube-proxy:v1.6.7

查看镜像：
docker images | grep proxy

systemctl  start kubelet.service

查看更新后版本
[root@tom-4 ~]# kubelet --version
Kubernetes v1.6.7



测试：
kubelet --version
kubectl version
systemctl status kubelet

[root@tom-3 ~]# docker load < /tmp/kube-proxy.tar
e621494a2487: Loading layer [==================================================>]  42.05MB/42.05MB
25ffec147d27: Loading layer [==================================================>]  4.744MB/4.744MB
d7aca1b11cbe: Loading layer [==================================================>]  64.02MB/64.02MB
Loaded image: gcr.io/google_containers/kube-proxy:e9033cca62c22462e4d265809247d752


[root@tom-3 ~]# 
[root@tom-3 ~]# kubectl edit ds/kube-proxy -n kube-system
daemonset "kube-proxy" edited
[root@tom-3 ~]# kubectl get pods -n 


恢复调度：
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

docker tag gcr.io/google_containers/kube-proxy:e9033cca62c22462e4d265809247d752 gcr.io/google_containers/kube-proxy:v1.6.7

docker tag gcr.io/google_containers/kube-scheduler:d0b09c97b763b940e4f6237bced5ec7d gcr.io/google_containers/kube-scheduler:v1.6.7

docker tag gcr.io/google_containers/kube-apiserver:0c91d6b7096af6d8c880c4502b8f945a gcr.io/google_containers/kube-apiserver:v1.6.7

docker tag gcr.io/google_containers/kube-controller-manager:2f24e64882bbd076fe023b64c621f595 gcr.io/google_containers/kube-controller-manager:v1.6.7



kubectl edit pod/kube-scheduler -n kube-system

kubectl edit pod/kube-apiserver -n kube-system

kubectl edit pod/kube-controller-manager -n kube-system


--storage-type=etcd2 --storage-media-type=application/json




/usr/bin/kubeadm version

mv /usr/bin/kubeadm /tmp/kubeadm_1.5
curl -o /usr/bin/kubeadm http://monkey.rhel.cc:8000/k8s_1_6/kubeadm
chmod 755  /usr/bin/kubeadm


查看由多个 container组成的容器时，使用-c 指定container
[root@tom-4 ~]# kubectl logs kube-dns-927355630-1pzv4  -n kube-system
Error from server (BadRequest): a container name must be specified for pod kube-dns-927355630-1pzv4, choose one of: [kube-dns dnsmasq dnsmasq-metrics healthz]
[root@tom-4 ~]# kubectl logs kube-dns-927355630-1pzv4  -n kube-system -c kube-dns



wget http://monkey.rhel.cc:8000/etcd-v3.2.2-linux-amd64/etcdctl
chmod 755 ./etcdctl
ETCDCTL_API=3 ./etcdctl migrat --data-dir=/opt/etcd/data/



升级完成后请重启
systemctl  restart calico
kubectl  get pods

导入新版
curl -o /tmp/kubernetes-dashboard-amd64_v1.6.1.tar http://monkey.rhel.cc:8000/k8s_1_6/kubernetes-dashboard-amd64_v1.6.1.tar
docker load < /tmp/kubernetes-dashboard-amd64_v1.6.1.tar

升级后最后看一下，那些容器状态是不正常的
kubectl  get pods --all-namespaces=true | grep -v Running

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




查看 apiserver的log中：
kubectl logs kube-apiserver-k8s-master -n kube-system -f
报错：
E0721 07:57:01.680037       1 cacher.go:274] unexpected ListAndWatch error: k8s.io/kubernetes/vendor/k8s.io/apiserver/pkg/storage/cacher.go:215: Failed to list *certificates.CertificateSigningRequest: no kind "CertificateSigningRequest" is registered for version "certificates.k8s.io/v1alpha1"


原因：
certificates.k8s.io/v1alpha1 接口在1.6中被删除，在1.6中被命名为：certificates.k8s.io/v1beta1

标准做法：
请参考这里：
https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/

在1.5中删除认证，再1.6中重新添加认证


非标准，但证实的办法，直接修改etcd中的字段

修改技巧：
cat csr-z2g50  | etcdctl put /registry/certificatesigningrequests/csr-z2g50


修改好后：
kubectl logs kube-controller-manager-k8s-node2 -n kube-system -f

kube-controller-manager 日志如下：

E0721 07:56:54.540403       1 reflector.go:201] k8s.io/kubernetes/pkg/client/informers/informers_generated/externalversions/factory.go:70: Failed to list *v1beta1.CertificateSigningRequest: the server cannot complete the requested operation at this time, try again later (get certificatesigningrequests.certificates.k8s.io)
I0721 07:57:03.410328       1 garbagecollector.go:116] Garbage Collector: All resource monitors have synced. Proceeding to collect garbage
W0721 08:08:18.345870       1 reflector.go:323] k8s.io/kubernetes/pkg/controller/garbagecollector/graph_builder.go:192: watch of <nil> ended with: etcdserver: mvcc: required revision has been compacted


[root@k8s-master manifests]# export ETCDCTL_API=3
[root@k8s-master manifests]# etcdctl get --prefix=true "" | grep certificates
[root@k8s-master manifests]# ETCDCTL_API=3 etcdctl get --prefix=true "" | grep certificates
/registry/certificatesigningrequests/csr-10zdt
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1alpha1","metadata":{"name":"csr-10zdt","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1alpha1/certificatesigningrequestscsr-10zdt","uid":"7514666b-556c-11e7-b587-5853c004060e","creationTimestamp":"2017-06-20T03:56:36Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlId01JR1dBZ0VBTURReEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekViTUJrR0ExVUVBeE1TYzNsegpkR1Z0T201dlpHVTZhR0YzWVdscE1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRVU2bVpwK0x5CldON0RFRlZ4UkdOeElnQkJ6MUFpeXdNajh0ei81SjRocFh6Ym84Znc2MGJhaGdaelZxcFRDQU5kRXFEWERPVDgKMnU0eURla2xCck5udjZBQU1Bb0dDQ3FHU000OUJBTUNBMGtBTUVZQ0lRRGFhREhsb0M3NHRtN2luOC9ENEVObgo2OE81Z3drUnQ4aEdsdkxCSDVHRWR3SWhBTWVzQnNkZERPNExnK0hINGdHYmUrdmFkYStNT0RTZUQ1QTF1bW1BClJjNk4KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNhakNDQVZLZ0F3SUJBZ0lVUEg2VFlCSzdqNkE1LzQvQm85TnJnNlNuR21rd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTJNakF3TXpVeU1EQmFGdzB4T0RBMgpNakF3TXpVeU1EQmFNRFF4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWJNQmtHQTFVRUF4TVNjM2x6CmRHVnRPbTV2WkdVNmFHRjNZV2xwTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFVTZtWnArTHkKV043REVGVnhSR054SWdCQnoxQWl5d01qOHR6LzVKNGhwWHpibzhmdzYwYmFoZ1p6VnFwVENBTmRFcURYRE9UOAoydTR5RGVrbEJyTm52Nk5lTUZ3d0RnWURWUjBQQVFIL0JBUURBZ1dnTUIwR0ExVWRKUVFXTUJRR0NDc0dBUVVGCkJ3TUJCZ2dyQmdFRkJRY0RBakFNQmdOVkhSTUJBZjhFQWpBQU1CMEdBMVVkRGdRV0JCUWgvM0szbkduQzQvd3MKdVlPbnBBWHZUcm5mQWpBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQVFFQWhjSTVVbFo3RGVrMVd1NWlMem16UjhmTApyK21mWFNzWU9HU0NhWmNWYmFMQ1kzVU5KajZZb2JSaTVtczBwYXRjRFFxVDBKb3F4Z0JWRU4vdTFqWG9ETi8rCk40NGlpNUE5K0F2YlNoTzEzdTBCWE9VSG02Vm03ZXpuS3paeHVvbVVKK1JEcXNiRUE3TGNBK3NHQ05DQ3hESk4KUkVMRzZyTDhuTVBDVlRrV002ejFub2JicjVyNE1DWStLZ25FY0Zqd0JVdkhQbkE5VVFZeW0rUVd3Mi8xRjAyUgpRSXNuMDZGZUU3QVd4UWVrUGxKMTl5SGpXRDk4UG12ZTBJbVpPQW5hTjlGSGFsUjBScTByRW1iZzN3VFFac0tGCmhLRThmbnRsN3E2cVJabmZLNk9pdmtrZFZ1N3pibGVCTVZnM2ZRMnFObTlDUDh5b3hYRGRrVDE2WWQyYmRBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="}}
/registry/certificatesigningrequests/csr-9j9l6
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1alpha1","metadata":{"name":"csr-9j9l6","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1alpha1/certificatesigningrequestscsr-9j9l6","uid":"f3a46c1e-16b5-11e7-869d-5853c004060e","creationTimestamp":"2017-04-01T08:33:59Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlIeU1JR1pBZ0VBTURjeEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekVlTUJ3R0ExVUVBeE1WYzNsegpkR1Z0T201dlpHVTZhemh6TFc1dlpHVXhNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUVMeHRYCm5XbXJKVEc1bi9sQTl2U3g1b29pdXhDMTZHaFVyRkZmeG9rS0RIUEVrWjMwNGNQT0hlWG02RVgyVExDeUh1SnQKSFk5OW5vK0JjQXZaMVB2SXY2QUFNQW9HQ0NxR1NNNDlCQU1DQTBnQU1FVUNJUUMwWG1ZMnpxSTR2SUV4TkQ3TApuQW9uS2hma3FlSm1mV1lvTlRkemRrNFAxZ0lnTjdjMFBjOWRpUjQ5ZzgzUyt5U2dYV0RrMnV3ejM5dkdNeDgrCmtmSkt2eE09Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNiVENDQVZXZ0F3SUJBZ0lVQzREL1YrYU1OWFUwUzdPSHlCRWJZZFBGMXpzd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTBNREV3T0RJNU1EQmFGdzB4T0RBMApNREV3T0RJNU1EQmFNRGN4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWVNQndHQTFVRUF4TVZjM2x6CmRHVnRPbTV2WkdVNmF6aHpMVzV2WkdVeE1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRUx4dFgKbldtckpURzVuL2xBOXZTeDVvb2l1eEMxNkdoVXJGRmZ4b2tLREhQRWtaMzA0Y1BPSGVYbTZFWDJUTEN5SHVKdApIWTk5bm8rQmNBdloxUHZJdjZOZU1Gd3dEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHCkFRVUZCd01CQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjBHQTFVZERnUVdCQlRBUWRtbGh2OFAKeHJ4NWlGRGg2TGRvMENJcHlEQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFQYlVTOE5mUWJtZVozVmlUaVNzZgp6Q2FPSEhpMVl4SkdSOUJtRFFQT2IxNnJtd0dLRDByRURkOVJvcnAxMVIzSGZRZ0R2UVkrWUN3K3RQNlE0NHlNClo3amQ1bmRYbFlLdnBRTTR2b1hzUjdobDV6MVNrbWsveU9VU0w2VnRzMC9EMUhrWUFDalNEMWhjUnFHZ0tuU20KRkZ0TEtOVlh0Y3lIZUpBV2ZpS3Z6VWJqZUpDeG9nbU41YnFwZlgwVDFBWGtBZW9IaWtDWnZURmlYcW8wRzQ5UwpRTkdEQkNHbkduQmF5UkYzSkYxYi9iWERSUFZMdTZ4UEZiaHp2QUUxVTNNbisrZHoyeEJ6VStyRWFwVkg0Rk5YCkFXdFBSdUdJU2RQOXpBRncvbnRYSkdhcmlrSnFLSzZObXZ4M28wa1RYdzRzYWZ6NzdOQTdEbkRpNE84Qy92RHUKZ0E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="}}
/registry/certificatesigningrequests/csr-lnq7k
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1alpha1","metadata":{"name":"csr-lnq7k","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1alpha1/certificatesigningrequestscsr-lnq7k","uid":"b1099bae-558c-11e7-b587-5853c004060e","creationTimestamp":"2017-06-20T07:47:21Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlIdk1JR1dBZ0VBTURReEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekViTUJrR0ExVUVBeE1TYzNsegpkR1Z0T201dlpHVTZhR0YzWVdscE1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRVk3U1ZZcGZiCmtha1VJR1VqY3pPdllkU0dIM3hMM2piT1FDc3F2dkI4SVRvVkNPZ0FMRWYxREMydVZNTmhtS1RtU3ZIV1VYbjkKUmZLOFZBZ0FZN0VvMDZBQU1Bb0dDQ3FHU000OUJBTUNBMGdBTUVVQ0lRRFBXTUxQS2Y2QkNKZktHb01PSmlmQQpmQnVVV011RWlqaUtUTE5Vd2NUakFnSWdhY1BzUzc2UzFZSGZ0dmRwOVZQL1NyQ2VuTENxVDdXU1NORnBDQytnCjA3Yz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNhakNDQVZLZ0F3SUJBZ0lVUExyWitJeU1HcEdsdGk1ZEZjRWpic0MzdFVNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTJNakF3TnpReU1EQmFGdzB4T0RBMgpNakF3TnpReU1EQmFNRFF4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWJNQmtHQTFVRUF4TVNjM2x6CmRHVnRPbTV2WkdVNmFHRjNZV2xwTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFWTdTVllwZmIKa2FrVUlHVWpjek92WWRTR0gzeEwzamJPUUNzcXZ2QjhJVG9WQ09nQUxFZjFEQzJ1Vk1OaG1LVG1TdkhXVVhuOQpSZks4VkFnQVk3RW8wNk5lTUZ3d0RnWURWUjBQQVFIL0JBUURBZ1dnTUIwR0ExVWRKUVFXTUJRR0NDc0dBUVVGCkJ3TUJCZ2dyQmdFRkJRY0RBakFNQmdOVkhSTUJBZjhFQWpBQU1CMEdBMVVkRGdRV0JCUVNIZEpmbkRsdGhINUoKQWVmVFRUazBVLy9RR3pBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQVFFQWFVOFoyUWx1YmtGdFc5UkVwTXo1dWdDYgptZXlNMzdWT1FwNkFNR0lReng0Nzk5SGc5L0J1R3RGNmg1UmJXV3ZIMmFCajhKcXZuUVJFRTV0cFlWS292WnB6CmN1cHJJdFQ3cUNTc0hBZndQQmY0T2wwU25JZ2dzaFAzdVd5Tnd0YWNscEZwRXNoY05FbzRkU2t0dVd3UVcrWDYKWHdRUE5ZOXRieFhXMk8yZlNYTFZ4QTJEOW0yakJCanVvYzAxS01zVzYwdE1NRmowSHI2UmJad3pVZVFOcTNRdgpoNmNRQk8yTkhGRnBrdFpsREgzalJNL2ZnU25uWjViaGd1dzJabkR5d3BSYWVLZW9DTmovTFJxekgzOWV4Qm1uCmwwWDJlWXkyalM4c0VwdEVzNVlDZkdFTG1Mb2RDcS9DZDdwZWY0OFI3UlJXc05laURWSStBWVFGOFN5VmpnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="}}
/registry/certificatesigningrequests/csr-z2g50
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1alpha1","metadata":{"name":"csr-z2g50","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1alpha1/certificatesigningrequestscsr-z2g50","uid":"f56a8f58-16b5-11e7-869d-5853c004060e","creationTimestamp":"2017-04-01T08:34:02Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlIeE1JR1pBZ0VBTURjeEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekVlTUJ3R0ExVUVBeE1WYzNsegpkR1Z0T201dlpHVTZhemh6TFc1dlpHVXlNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUV4N2RuCnR4Sysxa0wxNmY3RjB0Zm9sNDJEbEQ3ZFhCMDU3clk2aHp5MlhTVkJ3SzV5U1FpdmtuL0l6UXBzVHZ3YkYwcDcKWU9nQ0NZUnJvK0J1SkUwbTVxQUFNQW9HQ0NxR1NNNDlCQU1DQTBjQU1FUUNJRzVKaDFUN0hGQlNTQjlDaFo5bgp5NXpHbXpldm81eEhsc0RyWktRRnFFY2hBaUF5MzBiVVg0ZnBGM2JmS0x5emRLQU0xL2RzaHhtLzNESU13ZnEyCnBNbkMzZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNiVENDQVZXZ0F3SUJBZ0lVT20wUGI0dUtTUVdPQkZwSC9aUmV2WnZXSGxJd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTBNREV3T0RJNU1EQmFGdzB4T0RBMApNREV3T0RJNU1EQmFNRGN4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWVNQndHQTFVRUF4TVZjM2x6CmRHVnRPbTV2WkdVNmF6aHpMVzV2WkdVeU1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRXg3ZG4KdHhLKzFrTDE2ZjdGMHRmb2w0MkRsRDdkWEIwNTdyWTZoenkyWFNWQndLNXlTUWl2a24vSXpRcHNUdndiRjBwNwpZT2dDQ1lScm8rQnVKRTBtNXFOZU1Gd3dEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHCkFRVUZCd01CQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjBHQTFVZERnUVdCQlExUk9waG5WWkcKUTJXOExlVCtLUy9GQXF0Q1lEQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUF1SCtHQjQvQ1FmWmZSNEh5NmJOcwo0M3A2Sm9kWWZWVzBtc0o2cFZBOUhOZUJuYXhOYVZiYzVKUElJUDg4cUxBL1d6Y2JUcVBsb0VHOHB4S05pdFJMCnpjcFJYemFQMVJFM3dKVExsRTFVUzhBYVVlMFEyMkxaTWw2NmFrN2ViQlJDWjg5VUExWUxOcThDWjh3WnlpUWUKdDJWQzVQL0VmTGhMeFdpbXRlWFZPK3pzelhlWXFqUEJEaTVwOUxpMG1rQlRjaW10UHJxSVNqSDdpSmtMeG5EcwozdlVVUjRQM3ROUFFvcEZrdFNmQ3ZEYjZEczJnVlc3Rjh6SHNzcTV2b00ydUwybURGbXAwenptQnp2VTdETm1uCmVPV2sxUGtBQ2lJaURHeFRFNXJiMGNSSU9paUtvTXBTTm16NUpzaUI2cUR6b2w1VmY3UTBKM3BtMUFhMnVtYk8KREE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="}}

改成

[root@k8s-master manifests]# export ETCDCTL_API=3
[root@k8s-master manifests]# etcdctl get --prefix=true "" | grep certificates
/registry/certificatesigningrequests/csr-10zdt
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1beta1","metadata":{"name":"csr-10zdt","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1beta1/certificatesigningrequestscsr-10zdt","uid":"7514666b-556c-11e7-b587-5853c004060e","creationTimestamp":"2017-06-20T03:56:36Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlId01JR1dBZ0VBTURReEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekViTUJrR0ExVUVBeE1TYzNsegpkR1Z0T201dlpHVTZhR0YzWVdscE1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRVU2bVpwK0x5CldON0RFRlZ4UkdOeElnQkJ6MUFpeXdNajh0ei81SjRocFh6Ym84Znc2MGJhaGdaelZxcFRDQU5kRXFEWERPVDgKMnU0eURla2xCck5udjZBQU1Bb0dDQ3FHU000OUJBTUNBMGtBTUVZQ0lRRGFhREhsb0M3NHRtN2luOC9ENEVObgo2OE81Z3drUnQ4aEdsdkxCSDVHRWR3SWhBTWVzQnNkZERPNExnK0hINGdHYmUrdmFkYStNT0RTZUQ1QTF1bW1BClJjNk4KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNhakNDQVZLZ0F3SUJBZ0lVUEg2VFlCSzdqNkE1LzQvQm85TnJnNlNuR21rd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTJNakF3TXpVeU1EQmFGdzB4T0RBMgpNakF3TXpVeU1EQmFNRFF4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWJNQmtHQTFVRUF4TVNjM2x6CmRHVnRPbTV2WkdVNmFHRjNZV2xwTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFVTZtWnArTHkKV043REVGVnhSR054SWdCQnoxQWl5d01qOHR6LzVKNGhwWHpibzhmdzYwYmFoZ1p6VnFwVENBTmRFcURYRE9UOAoydTR5RGVrbEJyTm52Nk5lTUZ3d0RnWURWUjBQQVFIL0JBUURBZ1dnTUIwR0ExVWRKUVFXTUJRR0NDc0dBUVVGCkJ3TUJCZ2dyQmdFRkJRY0RBakFNQmdOVkhSTUJBZjhFQWpBQU1CMEdBMVVkRGdRV0JCUWgvM0szbkduQzQvd3MKdVlPbnBBWHZUcm5mQWpBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQVFFQWhjSTVVbFo3RGVrMVd1NWlMem16UjhmTApyK21mWFNzWU9HU0NhWmNWYmFMQ1kzVU5KajZZb2JSaTVtczBwYXRjRFFxVDBKb3F4Z0JWRU4vdTFqWG9ETi8rCk40NGlpNUE5K0F2YlNoTzEzdTBCWE9VSG02Vm03ZXpuS3paeHVvbVVKK1JEcXNiRUE3TGNBK3NHQ05DQ3hESk4KUkVMRzZyTDhuTVBDVlRrV002ejFub2JicjVyNE1DWStLZ25FY0Zqd0JVdkhQbkE5VVFZeW0rUVd3Mi8xRjAyUgpRSXNuMDZGZUU3QVd4UWVrUGxKMTl5SGpXRDk4UG12ZTBJbVpPQW5hTjlGSGFsUjBScTByRW1iZzN3VFFac0tGCmhLRThmbnRsN3E2cVJabmZLNk9pdmtrZFZ1N3pibGVCTVZnM2ZRMnFObTlDUDh5b3hYRGRrVDE2WWQyYmRBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="}}
/registry/certificatesigningrequests/csr-9j9l6
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1beta1","metadata":{"name":"csr-9j9l6","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1beta1/certificatesigningrequestscsr-9j9l6","uid":"f3a46c1e-16b5-11e7-869d-5853c004060e","creationTimestamp":"2017-04-01T08:33:59Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlIeU1JR1pBZ0VBTURjeEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekVlTUJ3R0ExVUVBeE1WYzNsegpkR1Z0T201dlpHVTZhemh6TFc1dlpHVXhNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUVMeHRYCm5XbXJKVEc1bi9sQTl2U3g1b29pdXhDMTZHaFVyRkZmeG9rS0RIUEVrWjMwNGNQT0hlWG02RVgyVExDeUh1SnQKSFk5OW5vK0JjQXZaMVB2SXY2QUFNQW9HQ0NxR1NNNDlCQU1DQTBnQU1FVUNJUUMwWG1ZMnpxSTR2SUV4TkQ3TApuQW9uS2hma3FlSm1mV1lvTlRkemRrNFAxZ0lnTjdjMFBjOWRpUjQ5ZzgzUyt5U2dYV0RrMnV3ejM5dkdNeDgrCmtmSkt2eE09Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNiVENDQVZXZ0F3SUJBZ0lVQzREL1YrYU1OWFUwUzdPSHlCRWJZZFBGMXpzd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTBNREV3T0RJNU1EQmFGdzB4T0RBMApNREV3T0RJNU1EQmFNRGN4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWVNQndHQTFVRUF4TVZjM2x6CmRHVnRPbTV2WkdVNmF6aHpMVzV2WkdVeE1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRUx4dFgKbldtckpURzVuL2xBOXZTeDVvb2l1eEMxNkdoVXJGRmZ4b2tLREhQRWtaMzA0Y1BPSGVYbTZFWDJUTEN5SHVKdApIWTk5bm8rQmNBdloxUHZJdjZOZU1Gd3dEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHCkFRVUZCd01CQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjBHQTFVZERnUVdCQlRBUWRtbGh2OFAKeHJ4NWlGRGg2TGRvMENJcHlEQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFQYlVTOE5mUWJtZVozVmlUaVNzZgp6Q2FPSEhpMVl4SkdSOUJtRFFQT2IxNnJtd0dLRDByRURkOVJvcnAxMVIzSGZRZ0R2UVkrWUN3K3RQNlE0NHlNClo3amQ1bmRYbFlLdnBRTTR2b1hzUjdobDV6MVNrbWsveU9VU0w2VnRzMC9EMUhrWUFDalNEMWhjUnFHZ0tuU20KRkZ0TEtOVlh0Y3lIZUpBV2ZpS3Z6VWJqZUpDeG9nbU41YnFwZlgwVDFBWGtBZW9IaWtDWnZURmlYcW8wRzQ5UwpRTkdEQkNHbkduQmF5UkYzSkYxYi9iWERSUFZMdTZ4UEZiaHp2QUUxVTNNbisrZHoyeEJ6VStyRWFwVkg0Rk5YCkFXdFBSdUdJU2RQOXpBRncvbnRYSkdhcmlrSnFLSzZObXZ4M28wa1RYdzRzYWZ6NzdOQTdEbkRpNE84Qy92RHUKZ0E9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="}}
/registry/certificatesigningrequests/csr-lnq7k
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1beta1","metadata":{"name":"csr-lnq7k","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1beta1/certificatesigningrequestscsr-lnq7k","uid":"b1099bae-558c-11e7-b587-5853c004060e","creationTimestamp":"2017-06-20T07:47:21Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlIdk1JR1dBZ0VBTURReEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekViTUJrR0ExVUVBeE1TYzNsegpkR1Z0T201dlpHVTZhR0YzWVdscE1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRVk3U1ZZcGZiCmtha1VJR1VqY3pPdllkU0dIM3hMM2piT1FDc3F2dkI4SVRvVkNPZ0FMRWYxREMydVZNTmhtS1RtU3ZIV1VYbjkKUmZLOFZBZ0FZN0VvMDZBQU1Bb0dDQ3FHU000OUJBTUNBMGdBTUVVQ0lRRFBXTUxQS2Y2QkNKZktHb01PSmlmQQpmQnVVV011RWlqaUtUTE5Vd2NUakFnSWdhY1BzUzc2UzFZSGZ0dmRwOVZQL1NyQ2VuTENxVDdXU1NORnBDQytnCjA3Yz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUgUkVRVUVTVC0tLS0tCg==","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNhakNDQVZLZ0F3SUJBZ0lVUExyWitJeU1HcEdsdGk1ZEZjRWpic0MzdFVNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTJNakF3TnpReU1EQmFGdzB4T0RBMgpNakF3TnpReU1EQmFNRFF4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWJNQmtHQTFVRUF4TVNjM2x6CmRHVnRPbTV2WkdVNmFHRjNZV2xwTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFWTdTVllwZmIKa2FrVUlHVWpjek92WWRTR0gzeEwzamJPUUNzcXZ2QjhJVG9WQ09nQUxFZjFEQzJ1Vk1OaG1LVG1TdkhXVVhuOQpSZks4VkFnQVk3RW8wNk5lTUZ3d0RnWURWUjBQQVFIL0JBUURBZ1dnTUIwR0ExVWRKUVFXTUJRR0NDc0dBUVVGCkJ3TUJCZ2dyQmdFRkJRY0RBakFNQmdOVkhSTUJBZjhFQWpBQU1CMEdBMVVkRGdRV0JCUVNIZEpmbkRsdGhINUoKQWVmVFRUazBVLy9RR3pBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQVFFQWFVOFoyUWx1YmtGdFc5UkVwTXo1dWdDYgptZXlNMzdWT1FwNkFNR0lReng0Nzk5SGc5L0J1R3RGNmg1UmJXV3ZIMmFCajhKcXZuUVJFRTV0cFlWS292WnB6CmN1cHJJdFQ3cUNTc0hBZndQQmY0T2wwU25JZ2dzaFAzdVd5Tnd0YWNscEZwRXNoY05FbzRkU2t0dVd3UVcrWDYKWHdRUE5ZOXRieFhXMk8yZlNYTFZ4QTJEOW0yakJCanVvYzAxS01zVzYwdE1NRmowSHI2UmJad3pVZVFOcTNRdgpoNmNRQk8yTkhGRnBrdFpsREgzalJNL2ZnU25uWjViaGd1dzJabkR5d3BSYWVLZW9DTmovTFJxekgzOWV4Qm1uCmwwWDJlWXkyalM4c0VwdEVzNVlDZkdFTG1Mb2RDcS9DZDdwZWY0OFI3UlJXc05laURWSStBWVFGOFN5VmpnPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="}}
/registry/certificatesigningrequests/csr-z2g50
{"kind":"CertificateSigningRequest","apiVersion":"certificates.k8s.io/v1beta1","metadata":{"name":"csr-z2g50","generateName":"csr-","selfLink":"/apis/certificates.k8s.io/v1beta1/certificatesigningrequestscsr-z2g50","uid":"f56a8f58-16b5-11e7-869d-5853c004060e","creationTimestamp":"2017-04-01T08:34:02Z"},"spec":{"request":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULS0tLS0KTUlIeE1JR1pBZ0VBTURjeEZUQVRCZ05WQkFvVERITjVjM1JsYlRwdWIyUmxjekVlTUJ3R0ExVUVBeE1WYzNsegpkR1Z0T201dlpHVTZhemh6TFc1dlpHVXlNRmt3RXdZSEtvWkl6ajBDQVFZSUtvWkl6ajBEQVFjRFFnQUV4N2RuCnR4Sysxa0wxNmY3RjB0Zm9sNDJEbEQ3ZFhCMDU3clk2aHp5MlhTVkJ3SzV5U1FpdmtuL0l6UXBzVHZ3YkYwcDcKWU9nQ0NZUnJvK0J1SkUwbTVxQUFNQW9HQ0NxR1NNNDlCQU1DQTBjQU1FUUNJRzVKaDFUN0hGQlNTQjlDaFo5bgp5NXpHbXpldm81eEhsc0RyWktRRnFFY2hBaUF5MzBiVVg0ZnBGM2JmS0x5emRLQU0xL2RzaHhtLzNESU13ZnEyCnBNbkMzZz09Ci0tLS0tRU5EIENFUlRJRklDQVRFIFJFUVVFU1QtLS0tLQo=","username":"kubeadm-node-csr","uid":"d9556a39-16b5-11e7-8bfc-5853c004060e","groups":["system:kubelet-bootstrap","system:authenticated"]},"status":{"conditions":[{"type":"Approved","reason":"AutoApproved","message":"Auto approving of all kubelet CSRs is enabled on the controller manager","lastUpdateTime":null}],"certificate":"LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUNiVENDQVZXZ0F3SUJBZ0lVT20wUGI0dUtTUVdPQkZwSC9aUmV2WnZXSGxJd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0ZURVRNQkVHQTFVRUF4TUthM1ZpWlhKdVpYUmxjekFlRncweE56QTBNREV3T0RJNU1EQmFGdzB4T0RBMApNREV3T0RJNU1EQmFNRGN4RlRBVEJnTlZCQW9UREhONWMzUmxiVHB1YjJSbGN6RWVNQndHQTFVRUF4TVZjM2x6CmRHVnRPbTV2WkdVNmF6aHpMVzV2WkdVeU1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRXg3ZG4KdHhLKzFrTDE2ZjdGMHRmb2w0MkRsRDdkWEIwNTdyWTZoenkyWFNWQndLNXlTUWl2a24vSXpRcHNUdndiRjBwNwpZT2dDQ1lScm8rQnVKRTBtNXFOZU1Gd3dEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEdBMVVkSlFRV01CUUdDQ3NHCkFRVUZCd01CQmdnckJnRUZCUWNEQWpBTUJnTlZIUk1CQWY4RUFqQUFNQjBHQTFVZERnUVdCQlExUk9waG5WWkcKUTJXOExlVCtLUy9GQXF0Q1lEQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUF1SCtHQjQvQ1FmWmZSNEh5NmJOcwo0M3A2Sm9kWWZWVzBtc0o2cFZBOUhOZUJuYXhOYVZiYzVKUElJUDg4cUxBL1d6Y2JUcVBsb0VHOHB4S05pdFJMCnpjcFJYemFQMVJFM3dKVExsRTFVUzhBYVVlMFEyMkxaTWw2NmFrN2ViQlJDWjg5VUExWUxOcThDWjh3WnlpUWUKdDJWQzVQL0VmTGhMeFdpbXRlWFZPK3pzelhlWXFqUEJEaTVwOUxpMG1rQlRjaW10UHJxSVNqSDdpSmtMeG5EcwozdlVVUjRQM3ROUFFvcEZrdFNmQ3ZEYjZEczJnVlc3Rjh6SHNzcTV2b00ydUwybURGbXAwenptQnp2VTdETm1uCmVPV2sxUGtBQ2lJaURHeFRFNXJiMGNSSU9paUtvTXBTTm16NUpzaUI2cUR6b2w1VmY3UTBKM3BtMUFhMnVtYk8KREE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="}}
