pip install httpie

查看api接口：
http k8s:8080

查看k8s支持的资源的种类：
http k8s:/api/v1


分别查看，集群的pod列表，Service列表，RC列表等：
http k8s:/api/v1/pods
http k8s:/api/v1/services
http k8s:/api/v1/replicationcontrollers


如果每个节点的kubelet 启动时包含--enable-debugging-handlers = true，kubernates proxy api会增加，对node下pod的run，exec等的操作


如何使用k8s proxy访问服务


1. 获取pod 名字
kubectl get pods

比如pod 名字是httpd-deployment-2952969337-v5mr9

使用下面的连接，可以直接访问pod对应的服务
http://k8s:8080/api/v1/proxy/namespaces/default/pods/httpd-deployment-2952969337-v5mr9/


访问service
kubectl get svc
定义:/api/v1/proxy/namespaces/{namespace}/services/{name}
http://k8s:8080/api/v1/proxy/namespaces/default/services/my-nginx/