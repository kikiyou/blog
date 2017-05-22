1. docker中的日志处理
[使用ELK处理Docker日志(一)](https://segmentfault.com/a/1190000009102612)
[使用ELK处理Docker日志(二)](https://segmentfault.com/a/1190000009118076)


[如何在 Rancher 中统一管理容器日志](https://segmentfault.com/a/1190000007693996)
可以参考学习使用，rsyslog 直接输出json到elasticsearch中

[rsyslog通过自定义json格式发送日志信息给logstash](http://188533.blog.51cto.com/178533/1716985)




docker日志处理三种方法：
docker  --> rsyslog  --> kafaka --> logstash --> elasticsearch
docker  --> rsyslog  --> filebeat  --> elasticsearch
docker  --> filebeat  --> elasticsearch