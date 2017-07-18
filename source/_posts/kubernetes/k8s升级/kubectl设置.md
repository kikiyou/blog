[root@tom-4 ~]# kubectl  get pods
The connection to the server localhost:8080 was refused - did you specify the right host or port?



分发 kubeconfig 文件

cp /etc/kubernetes/admin.conf ~/.kube/config
chmod 644 ~/.kube/config


将 admin.conf 文件拷贝到运行 kubelet 命令的机器的 ~/.kube/ 目录下。
