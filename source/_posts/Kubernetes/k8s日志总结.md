
## 我们公司的日志现状

日志有两类: 
1. 网元日志
2. tomcat的日志

对于网元日志  
收集办法是： ``` 网元(log4j)  ->  rysylogd -> kafaka  -> logstash -> elasticsearch -> kibana ```

对于tomcat日志

tomcat日志输出到对应网元的 log目录下面
比如：aaa

``` 
/opt/fonsview/NE/aaa/log/aaa.log
/opt/fonsview/NE/aaa/log/aaa.log.2017-06-22
```

## docker 对于日志的处理

### 1.6 版本以前

+ 存储方式:

    1. Docker仅仅是从容器中采集stdout和sterr
    2. 用JSON进行简单的封装并存储到磁盘

+ 日志收集的演进：

    1. Docekr的早期使用者会收集 /var/lib/docker/containers/**

        ```缺点： 必须用root用户才能得到```
    2. 之后较好的用户体验方式: docker logs ，直接使用获取日志的 daemon API
    3. logspout开源项目的出现,对接API,转发syslog

### Docker 1.6 之后

引入日志驱动器(Log Drivers),除了默认json-file外，还支持将日志写到:
``` bash
    none   docker日志不会返回任何输出，容器将无法使用日志。

    json-file	日志格式为JSON。 Docker的默认日志记录驱动程序。

    syslog   将log信息写入syslog工具。

    journald	将log信息写入journald工具。

    gelf   将log信息使用 Graylog Extended Log Format (GELF) 写入  Graylog 或 Logstash。

    fluentd   将log信息写入 fluentd (forward input).

    awslogs   将log信息写入 Amazon CloudWatch Logs.

    splunk   将log信息写入 splunk 使用 HTTP Event Collector.

    etwlogs   将log信息写入 Event Tracing for Windows (ETW) events. 只windows平台可用

    gcplogs   将log信息写入 Google Cloud Platform (GCP) Logging.

``` 
![日志驱动](file:///home/monkey/Pictures/monitoring-and-log-management-small.jpg)


+ log-driver 支持全局daemon 和 单独容器
``` bash
    docker daemon --log-driver
    docker run --log-driver
```
+ json-file：
``` bash
    -log-opt max-size=10m   设置文件大小
    --log-opt max-file=3    设置日志保留数量
``` 

+ syslog:
``` bash
docker run --log-driver syslog \
--log-opt syslog-facility=daemon \
--log-opt syslog-address=udp://172.16.18.30:514 \
--log-opt tag="{{.ImageName}}/{{.Name}}/{{.ID}}"

收集到的日志:
<30>Jun 21 17:05:12 monkey.fonsview.com docker/nginx/monkey-nginx/5790672ab6a0[14077]: 3549: Wed Jun 21 09:05:12 UTC 2017
```
+ gelf
``` bash
ExecStart=/usr/bin/dockerd \
--log-driver=gelf \
--log-opt gelf-address=udp://172.16.18.30:12201 \
--log-opt tag=k8s-node1 \
--log-opt labels=io.kubernetes.pod.namespace,io.kubernetes.container.name,io.kubernetes.pod.name
```

### docker官方的想法: 
日志：

应用本身从不考虑存储自己的输出流。

不应该试图去写或者管理日志文件。

相反,***每一个运行的进程都会直接的标准输出(stdout)事件流。***

开发环境中,开发人员可以通过这些数据流,实时在终端看到应用的活动。

### 比较著名的镜像是怎么处理日志

一般官方镜像都会把日志转发到标准输出,但是做法各有特色,
比较有代表性的有如下三种：

+ Nginx

    官方nginx 的Dockerfile 中会有如下两条命令，转发到标准输出
    ``` bash
    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log \
    ln -sf /dev/stderr /var/log/nginx/error.log
    ```
    [官方：nginx Dockerfil](https://github.com/nginxinc/docker-nginx/blob/8921999083def7ba43a06fabd5f80e4406651353/mainline/jessie/Dockerfile#L21-L23)

+ httpd(apache)

    http官方的方法是 修改httpd.conf配置文件：
    ``` bash
    把 访问 和 错误 修改配置文件，输出到这里
    /proc/self/fd/1 (which is STDOUT)
    /proc/self/fd/2 (which is STDERR)
    ```
    [官方：httpd Dockerfil](https://github.com/docker-library/httpd/blob/b13054c7de5c74bbaa6d595dbe38969e6d4f860c/2.2/Dockerfile#L72-L75)

+ tomcat

    tomcat官方的方法是 

    ```使用catalina.sh run 启动tomcat，把所有输出打印到stdout ```

    [官方：tomcat Dockerfil](https://github.com/docker-library/tomcat/blob/5ac222d258dc70c77bb3a9a4fab81ea286c9abd1/7/jre8-alpine/Dockerfile)

## 比较有代表性的日志收集方案

### logspout

    logspout 监控docker.sock,现在它仅捕获STDOUT和STDERR,并转发到rsyslog,kafaka,logstsh等。
    Logspout 可作为独立程序，也可以作为一个Docker容器，大小仅15.2MB。

    使用方法：

+ 转发到rsyslog
    ``` bash
    $ docker run --name="logspout" \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        gliderlabs/logspout \
        syslog+tls://rsyslogd.fonsview.com:514
    ```
+ 使用浏览器访问
    ``` bash
    $ docker run -d --name="logspout" \
        --volume=/var/run/docker.sock:/var/run/docker.sock \
        --publish=127.0.0.1:8000:80 \
        gliderlabs/logspout

    $ curl http://127.0.0.1:8000/logs
    ```
    通过浏览器，即可访问到这台主机上所有容器的log

    更多高级功能请看：

    [logspout github地址](https://github.com/gliderlabs/logspout)

### kubernetes 官方推荐日志收集方案
**注：fluentd  不是 flume**

#### fluentd + ELK

对于fluentd怎么收集日志，有两种选择：

1. 每个台服务器一个fluentd
    ``` bash
    将ElesticSearch和kibana都运行在k8s集群中，然后用daemonset运行fluentd,
    fluentd的tail插件扫描每个容器日志文件 /var/lib/docker/containers/*/*.log 中的日志转发到 elasticsearch

    具体思路：
        主机默认使用json-file把，所有日志记录在/var/lib/docker/containers

    使用卷映射：
        /var/lib/docker/containers:/var/log
        这样就可以在flume容器中收集，主机上所有的日志。
    ```
2. 每个pod一个flume
``` bash
（1） 建立一个pod中共享的emptyDir volume
（2） 应用把日志打到emptyDir volume
（3） flume读取 emptyDir volume中的信息到 elasticsearch
```
### 使用docker的--log-driver 与 kubernetes官方推荐 对比

+ log-driver

    ``` docker使用--log-driver=gelf  -->  logstash --> elasticsearch --> kibana ```

    优势： 所有日志没有写本地和写文本操作,不占用磁盘io，日志只持久化到 elasticsearch

    劣势: 因为所有日志都转发到远程，kubernetes本身的dashboard View logs和 kubectl logs 无法使用

+ kubernetes推荐（fluentd + ELK）

![fluend+ELK](file:///home/monkey/Pictures/fluend+ELK.png)

``` fluentd（daemonset运行在每个node） --> elasticsearch --> kibana```

    优势： 官方推荐，日志组件完全在kubernetes控制下，效率与稳定性有保障。

    劣势： 日志会写本地，占用磁盘io,并且fluentd不承担日志轮询分割的任务，kubernetes推荐使用系统自带的logrotate 每天对大于100MB的日志进行轮询。

