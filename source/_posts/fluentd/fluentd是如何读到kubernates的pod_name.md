# fluentd是如何读到kubernates的pod_name

``` bash
使用docker默认的json-file输出的log基本是下面这样的:

{"log":"2017/07/05 21:15:03 Got request with path wombat\n",
 "stream":"stderr",
  "time":"2014-07-05T21:15:03.499185026Z"}

通常情况下，docker中的日志会存放在像下面这样的目录下

 /var/lib/docker/containers/997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b

会存如下的文件:

 997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b-json.log

其中 997599971ee6... 是docker的运行id
Kubernetes kubelet组件，会自动在主机上的/var/log/containers目录下创建一个软连接到这个文件，这个软连接包括了pod name和kubernates container name
就像下面:

   synthetic-logger-0.25lps-pod_default_synth-lgr-997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b.log 
   ->
   /var/lib/docker/containers/997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b/997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b-json.log

在每台主机的/var/log目录会被映射到Fluentd容器中，Fluentd会收集这个文件：

  /var/log/containers/synthetic-logger-0.25lps-pod_default_synth-lgr-997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b.log

这个文件会被命名成tag:

 var.log.containers.synthetic-logger-0.25lps-pod_default_synth-lgr-997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b.log

Kubernetes fluentd plugin 会从文件名中提取namespace,pod name 和container name来扩展每条log的字段，添加到日志消息中，用以标记log来自那里，并且会在tag中增加kubernates
最终tag是这样的:

  kubernetes.var.log.containers.synthetic-logger-0.25lps-pod_default_synth-lgr-997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b.log

同时，最终的发给elasticsearch的日志记录是下面这样的
{
  "log":"2017/07/05 21:15:03 Got request with path wombat\n",
  "stream":"stderr",
  "time":"2017-07-05T21:15:03.499185026Z",
  "kubernetes": {
    "namespace": "default",
    "pod_name": "synthetic-logger-0.25lps-pod",
    "container_name": "synth-lgr"
  },
  "docker": {
    "container_id": "997599971ee6366d4a5920d25b79286ad45ff37a74494f262e3bc98d909d0a7b"
  }
}
这样，当使用kibana来查询日志的时候，就可以通过pod_name或Kubernetes container来方便的搜索到你想要的log了
```