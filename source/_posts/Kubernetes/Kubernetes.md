## k8s 介绍

``` shell
# 启动一个单节点的集群
## 启动etcd集群
docker run -d --name=etcd \
    --net=host \
    gcr.io/google_containers/etcd:2.2.1 \
    /usr/local/bin/etcd \
    --listen-client-urls=http://0.0.0.0:4001 \
    --advertise-client-urls=http://0.0.0.0:4001 \
    --data-dir=/var/etcd/data

这条命令，启动一个 单节点etcd集群 侦听4001端口
--net=host 意思是这个容器 共享同一个网络名字叫host
生产环境上，推荐你启动三个节点的etcd集群 保证可用性


## API server
Kubernetes 是一段组件的联合统称，hyperkube运行你运行多个组件，第一个组件就是API server
docker run -d --name=api \
    --net=host --pid=host --privileged=true \
    gcr.io/google_containers/hyperkube:v1.2.2 \
    /hyperkube apiserver \
    --insecure-bind-address=0.0.0.0 \
    --service-cluster-ip-range=10.0.0.1/24 \
    --etcd_servers=http://127.0.0.1:4001

## Master
docker run -d --name=kubs \
  --volume=/:/rootfs:ro \
  --volume=/sys:/sys:ro \
  --volume=/dev:/dev \
  --volume=/var/lib/docker/:/var/lib/docker:rw \
  --volume=/var/lib/kubelet/:/var/lib/kubelet:rw \
  --volume=/var/run:/var/run:rw \
  --net=host \
  --pid=host \
  --privileged=true \
  gcr.io/google_containers/hyperkube:v1.2.2 \
  /hyperkube kubelet \
  --containerized \
  --hostname-override="0.0.0.0" \
  --address="0.0.0.0" \
  --cluster_dns=10.0.0.10 --cluster_domain=cluster.local \
  --api-servers=http://localhost:8080 \
  --config=/etc/kubernetes/manifests-multi

Master 是集群的控制单元，这个master 管理调度一个新的容器在哪个节点运行
其中 控制管理处理复制  调度服务 追踪资源的使用

## Proxy
docker run -d --name=proxy\
    --net=host \
    --privileged \
    gcr.io/google_containers/hyperkube:v1.2.2 \
    /hyperkube proxy \
    --master=http://0.0.0.0:8080 --v=2
任何节点对集群的请求都会通过代理服务来转发，它处理负载均衡和两个容器之间的通信

## Kubectl
Kubectl是个命令行客户端来和Master进行通信。
curl -o ~/.bin/kubectl http://storage.googleapis.com/kubernetes-release/release/v1.2.2/bin/linux/amd64/kubectl
chmod u+x ~/.bin/kubectl

使用这个客户端，要定义一个环境变量
export KUBERNETES_MASTER=http://host01:8080

## KubeDNS / SkyDNS
Kubernetes  使用 etc的 它的关系型DNS服务叫做 SkyDNS
kubectl create -f ~/kube-system.json
kubectl create -f ~/skydns-rc.yaml
kubectl create -f ~/skydns-svc.yaml



  > cat kube-system.json
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "kube-system"
  }
}



      
## Kube UI
使用下面 命令 启动 图形面板
kubectl create -f ~/dashboard.yaml


dashboard.yaml 中内容

kind: List
apiVersion: v1
items:
- kind: ReplicationController
  apiVersion: v1
  metadata:
    labels:
      app: kubernetes-dashboard
      version: v1.0.1
    name: kubernetes-dashboard
    namespace: kube-system
  spec:
    replicas: 1
    selector:
      app: kubernetes-dashboard
    template:
      metadata:
        labels:
          app: kubernetes-dashboard
      spec:
        containers:
        - name: kubernetes-dashboard
          image: gcr.io/google_containers/kubernetes-dashboard-amd64:v1.0.1
          imagePullPolicy: Always
          ports:
          - containerPort: 9090
            protocol: TCP
          args:
            - --apiserver-host=172.17.0.28:8080
          livenessProbe:
            httpGet:
              path: /
              port: 9090
            initialDelaySeconds: 30
            timeoutSeconds: 30
- kind: Service
  apiVersion: v1
  metadata:
    labels:
      app: kubernetes-dashboard
      kubernetes.io/cluster-service: "true"
    name: kubernetes-dashboard
    namespace: kube-system
  spec:
    type: NodePort
    ports:
    - port: 80
      targetPort: 9090
    selector:
      app: kubernetes-dashboard
------------------------------------------

## 健康检查
curl http://host01:4001/version
curl http://host01:8080/version
export KUBERNETES_MASTER=http://host01:8080
kubectl cluster-info   查看集群信息
kubectl get nodes

> cat /home/scrapbook/.bin/launch.sh
echo "Starting Kubernetes v1.2.2..."
docker run -d --net=host gcr.io/google_containers/etcd:2.2.1 /usr/local/bin/etcd --list
en-client-urls=http://0.0.0.0:4001 --advertise-client-urls=http://0.0.0.0:4001 --data-d
ir=/var/etcd/data
docker run -d --name=api --net=host --pid=host --privileged=true gcr.io/google_containe
rs/hyperkube:v1.2.2 /hyperkube apiserver --insecure-bind-address=0.0.0.0 --service-clus
ter-ip-range=10.0.0.1/24 --etcd_servers=http://127.0.0.1:4001 --v=2
docker run -d --name=kubs --volume=/:/rootfs:ro --volume=/sys:/sys:ro --volume=/dev:/de
v --volume=/var/lib/docker/:/var/lib/docker:rw --volume=/var/lib/kubelet/:/var/lib/kube
let:rw --volume=/var/run:/var/run:rw --net=host --pid=host --privileged=true gcr.io/goo
gle_containers/hyperkube:v1.2.2 /hyperkube kubelet --allow-privileged=true --containeri
zed --enable-server --hostname-override="127.0.0.1" --address="0.0.0.0" --api-servers=h
ttp://0.0.0.0:8080 --cluster_dns=10.0.0.10 --cluster_domain=cluster.local --config=/etc
/kubernetes/manifests-multi
echo "Downloading Kubectl..."
curl -o ~/.bin/kubectl http://storage.googleapis.com/kubernetes-release/release/v1.2.2/
bin/linux/amd64/kubectl
chmod u+x ~/.bin/kubectl
export KUBERNETES_MASTER=http://host01:8080
echo "Waiting for Kubernetes to start..."
until $(kubectl cluster-info &> /dev/null); do
  sleep 1
done
echo "Starting Kubernetes Proxy..."
docker run -d --name=proxy --net=host --privileged gcr.io/google_containers/hyperkube:v
1.2.2 /hyperkube proxy --proxy-mode=userspace --master=http://0.0.0.0:8080 --v=2
echo "Kubernetes started"
echo "Starting Kubernetes DNS..."
kubectl -s http://host01:8080 create -f ~/kube-system.json
kubectl -s http://host01:8080 create -f ~/skydns-rc.yaml
kubectl -s http://host01:8080 create -f ~/skydns-svc.yaml
echo "Starting Kubernetes UI..."
kubectl -s http://host01:8080 create -f ~/dashboard.yaml
kubectl -s http://host01:8080 cluster-info

```