# 使用kubeadm 启用一个多节点的集群

## 初始化 Master
kubeadm init --token=102952.1a7dd4cc8d1f4cc5

把另一个节点加到集群
kubeadm join --token=102952.1a7dd4cc8d1f4cc5 172.17.0.44:6443


在master上查看 集群信息
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf


kubectl get nodes

## 部署docker 网络接口

在mster上
curl -L https://git.io/weave-kube-1.6 -o /opt/weave-kube
cat /opt/weave-kube
kubectl apply -f /opt/weave-kube
kubectl get pod -n kube-system

## 部署pod
kubectl run http --image=katacoda/docker-http-server:latest --replicas=1
kubectl get pods

在节点主机上执行，可以看到真实的容器
docker ps | head -n2


## 在远程工作
cat /etc/kubernetes/admin.conf
scp root@<master ip>:/etc/kubernetes/admin.conf .
kubectl --kubeconfig ./admin.conf get nodes

## 部署图形界面
kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts;
kubectl apply -f dashboard.yaml
kubectl get pods -n kube-system