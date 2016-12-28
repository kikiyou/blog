# rabbitmq 消息队列

## rabbitmq 访问地址
http://172.16.199.206:15672/  后台web访问地址

添加 tracing  ,查看消息是否发送过来

1. 登录
2. 在Admin -> Tracing -> Add trace
                            - Name : 11
                            - Format: text
                            - Pattern: #
3. 查看
http://172.16.199.206:15672/api/trace-files/11.log

这时,向rabbitmq 发送消息,就可以查看到日志了


# 学习参考资料

[在 Ubuntu Linux 中安装与使用 RabbitMQ 消息队列](https://blog.gtwang.org/linux/ubuntu-linux-install-rabbitmq/)

[以 RabbitMQ 實作工作佇列（Work Queues）（Python 版本）](https://blog.gtwang.org/programming/rabbitmq-work-queues-in-python/)
[RabbitMQ消费者的几个参数](http://www.jianshu.com/p/04a1d36f52ba)
[RabbitMQ基础概念详细介绍](http://blog.csdn.net/whycold/article/details/41119807)
[RabbitMQ概念及环境搭建（三）RabbitMQ cluster](http://blog.csdn.net/zyz511919766/article/details/41896747)
[RabbitMQ 分布式设置和高可用性讨论](https://geewu.gitbooks.io/rabbitmq-quick/content/RabbitMQ%E5%88%86%E5%B8%83%E5%BC%8F%E8%AE%BE%E7%BD%AE%E4%B8%8E%E9%AB%98%E5%8F%AF%E7%94%A8%E6%80%A7%E8%AE%A8%E8%AE%BA.html)
[RabbitMQ在分布式系统中的应用](http://www.jianshu.com/p/f2d3c544d3c7)
fonsview 的aaa 和oss 的消息队列方式

aaa_exchange topic
oss_exchange topic
