# k8s 集成calico网络
下载：
http://hn-1251586848.cosgz.myqcloud.com/calico_node_v1.2.1.tar

1. calico/node 容器 必须在master和每个节点
2. calico/kube-policy-controller 容器
3. The calico-cni network plugin binaries

docker pull quay.io/calico/node:v1.2.1


# Download and install `calicoctl`
wget http://www.projectcalico.org/builds/calicoctl
sudo chmod +x calicoctl

# Run the calico/node container
sudo ETCD_ENDPOINTS=http://<ETCD_IP>:<ETCD_PORT> ./calicoctl node run