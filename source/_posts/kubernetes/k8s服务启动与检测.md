#k8s服务启动与检测

1. 启动etcd
systemctl  status etcd

alias etcdctl="/root/local/bin/etcdctl \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/flanneld/ssl/flanneld.pem \
  --key-file=/etc/flanneld/ssl/flanneld-key.pem"


etcdctl cluster-health


2. 启动Flannel网络
systemctl status flanneld


etcdctl ls /kubernetes/network/subnets

3. 启动master节点

master节点包括：
kube-apiserver
kube-scheduler
kube-controller-manager

systemctl status kube-apiserver
systemctl status kube-controller-manager
systemctl status kube-scheduler

验证master节点功能：
kubectl get componentstatuses

4. 启动node节点
flanneld
docker
kubelet
kube-proxy

systemctl status kubelet
systemctl status docker

kubectl get nodes

sudo iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat
systemctl restart  kubelet


5. 全局检测
查看端口映射：
kubectl get services kubernetes-dashboard -n kube-system


kubectl get pods --all-namespaces=true -o wide



kubectl proxy --address='172.16.6.43' --port=8086 --accept-hosts='^*$'