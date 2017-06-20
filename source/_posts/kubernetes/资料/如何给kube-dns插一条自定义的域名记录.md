
[原帖](http://www.datastart.cn/tech/2017/04/21/k8s-dns.html)

kube-dns原理解析
如何增加一条记录呢？
kube-dns原理解析

在我们用的kubernetes 1.5.4版本里，kube-dns与之前版本的实现有所不同。

旧版本中，kube-dns由4个容器组成：

etcd，存储dns数据
kube2sky，作为桥梁，监控kubernetes api server，向skydns写入DNS规则
skydns，提供DNS服务
healthz，健康检测
但在我们的1.5.4版本中，kube-dns只有3个容器：

kube-dns，类似kube2sky，监控api server的service变化，直接提供DNS服务(使用了skydns)，数据保存于内存中；监控10053端口
dnsmasq，作为kube-dns的DNS缓存；监控53端口
healthz，健康检测
1.5.4版本中，去掉了etcd的要求，但是增加了dnsmasq缓存。下面来看看在集群内一个Pod上进行一条DNS域名的解析过程。

k8s在拉起容器时，会设置容器的ResolvConfPath，将容器内的/etc/resolv.conf，指定为宿主机上的文件，该文件的内容如下。

search default.svc.cluster.local svc.cluster.local cluster.local
nameserver 10.96.0.10
options ndots:5
nameserver的地址，即kube-dns的service。而这个service的endpoint，就是前面所述dnsmasq监听的端口。

kubectl get svc -n kube-system
NAME                   CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
kube-dns               10.96.0.10       <none>        53/UDP,53/TCP   1d
kubectl describe svc kube-dns -n kube-system
Name:			kube-dns
Namespace:		kube-system
Labels:			component=kube-dns
			k8s-app=kube-dns
			kubernetes.io/cluster-service=true
			name=kube-dns
			tier=node
Selector:		name=kube-dns
Type:			ClusterIP
IP:			10.96.0.10
Port:			dns	53/UDP
Endpoints:		10.244.0.5:53
Port:			dns-tcp	53/TCP
Endpoints:		10.244.0.5:53
Session Affinity:	None
No events.
那么dnsmasq跟kube-dns是怎么关联起来的呢？我们进到dnsmasq这个容器里，看下dnsmasq启动的参数。

ps aux|grep dnsmasq
    1 root       0:04 /usr/sbin/dnsmasq --keep-in-foreground --cache-size=1000 --no-resolv  --server=127.0.0.1#10053
显然，dnsmasq的上线server是127.0.0.1#10053，也就是同属于一个Pod的kube-dns。（还记得吗，同一个Pod属于同一网络namespace）

官网

如何增加一条记录呢？

虽然可以为dnsmasq设置upstream域名服务器，但上级dns服务器一般我们管不着，所以看上去，要么在kube-dns里增加记录，要么在dnsmasq中增加记录。

在1.6版本里，增加了一个subDomain概念（如下图），即，可以为dnsmasq设置一个自定义的DNS服务器；这样当有需要设置新的域名解析时，只需要向自定义DNS服务器增加记录即可。

官网

但这样必须增加一个custom dns server。其实，我们只是为了把几台物理机的主机名加到DNS解析（需要在容器里通过域名来解析Hadoop中的hdfs/yarn配置），引入一个自定义DNS服务器，有点太重。

有没有更简单直接的方案呢？关键还是落在dnsmasq上。

dnsmasq支持读取/etc/hosts文件作为自己的DNS记录，如果/etc/hosts解析不方便的话，还可以指定–addn-hosts，指定某一文件作为hosts添加到dnsmasq缓存中。所以现在方案就简单了：

创建一个configmap，其内容为待解析的域名记录；将configmap作为volume挂载到dnsmasq容器的/dns目录下，然后为dnsmasq增加参数–addn-hosts=/dns/key，宿主机主机名记录就可以加到dnsmasq中去了。

如果集群扩容，configmap更新了呢？我们知道configmap更新了以后，会更新挂载到容器中的文件；但遗憾的是，dnsmasq并不会管addn-hosts的文件的变化，新机器的主机名并不能加到kube-dns中。

办法也有，因为kube-dns是一个deployment，所以可以将其scaleout 1 -> 0 -> 1：

kubectl scale kube-dns --replicas=0 -n kube-system
kubectl scale kube-dns --replicas=1 -n kube-system
缺点就是集群内会暂时关闭DNS解析。