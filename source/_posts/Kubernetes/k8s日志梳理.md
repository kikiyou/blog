# k8s日志梳理

docker 原生nginx日志处理

1. nginx日志会原生转发到标准输入和输出

# forward request and error logs to docker log collector
&& ln -sf /dev/stdout /var/log/nginx/access.log \
&& ln -sf /dev/stderr /var/log/nginx/error.log

2. http官方的方法是 修改配置文件
把 访问 和 错误 修改配置文件，输出到这里
/proc/self/fd/1 (which is STDOUT)
/proc/self/fd/2 (which is STDERR)


2. 再在docker层 指定 docker daemon --log-driver

比如如下：
    logging:
      driver: syslog
      options:
        syslog-address: "tcp://192.168.2.121:514" # 内网IP
        tag: "{{.Name}}.{{.ID}}"

[Docker集群日志收集：Syslog+Rsyslog+ELK](https://zhuanlan.zhihu.com/p/24912074)
-----------------
在每个node上各运行一个Flunetd容器，对本节点 /var/log 和 /var/lib/docker/containers/ 两个目录下的日志进行采集，然后汇总到elasticsearch集群，最后通过kibana展示。

为了让fluentd在每个node上运行一份，这里有几种不同的方法：

1、直接在Node宿主机上安装fluentd。这种方法适合elk都安装在物理机上的场景。

2、利用kubelet的–config参数，为每个node分别运行一个静态fluentd pod。

3、利用daemonset来让fluentd分别在每个node上运行一个pod。（daemontset是k8s的一种资源对象）

官方使用的是第三种方式，将ElesticSearch和kibana都运行在k8s集群中，然后用daemonset运行fluentd。具体实现过程github上有示例文件，这里不做详细描述。

------------
logspout  监控docker的socket

-----------
It's plugged into Docker by using following arguments: "--log-driver=syslog --log-opt syslog-address=udp://localhost:8061 --log-opt tag={{.Name}}/{{.ID}}/{{.ImageName}}".

### 官方推荐的日志收集-fluentd
1. fluentd运行在每个node上，共享主机的卷

实现方式是每个agent挂载目录/var/lib/docker/containers使用fluentd的tail插件扫描每个容器日志文件，直接发送给Elasticsearch。

2. fluentd运行在每个pod,两个容器共享 emptyDir volume，收集数据



## docker plugin system  默认docker 1.12中实验性提供
Logging driver plugins are available in Docker 17.05 and higher.

实现新的plugin命令来管理各种插件，同时实现了该命令下的子命令install,enbale,disable,rm,inspect,set

1.13：
为fluentd日志驱动添加unix socket的支持


17.05
日志

添加日志插件的支持
在docker service logs命令以及API接口/task/{id}/logs支持针对单个任务的日志显示
添加--log-opt env-regex选项来使用正则表达式匹配环境变量

----------
Configure the logging driver for a container


[日志输出到文件]https://zhuanlan.zhihu.com/p/24912074

$ docker run --log-driver=fluentd --log-opt fluentd-address=myhost.local:24224 --log-opt tag="mailer"


老版本全局设置：
dockerd \
  --log-driver syslog \
  --log-opt syslog-address=udp://1.2.3.4:1111


新版本,可指定单个容器：
You can set the logging driver for a specific container by using the --log-driver flag to docker create or docker run:

docker run \
      -–log-driver syslog –-log-opt syslog-address=udp://1.2.3.4:1111 \
      alpine echo hello world


[docker和kubernetes日志收集方案](http://www.do1618.com/archives/908)
$ docker run -it --log-opt max-size=10m --log-opt max-file=3 busybox /bin/sh -c 'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 0.001; done'
