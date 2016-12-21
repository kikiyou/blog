概念问题
kafaka和zookeeper的群集，使用samsa的时候生产者和消费者都连接了zookeeper，但是我跟峰云（大数据大牛，运维屌丝逆转）沟通，他们使用的时候是生产者直接连接kafaka服务器列表，消费者才用zookeeper。这也解决了我看pykafka文档，只有消费者才连接zookeeper的困惑，所以问题解决，直接按照文档搞起。

生产者
>>> from pykafka import KafkaClient
>>> client = KafkaClient(hosts="192.168.1.1:9092, 192.168.1.2:9092") # 可接受多个Client这是重点
>>> client.topics  # 查看所有topic
>>> topic = client.topics['my.test'] # 选择一个topic
>>> producer = topic.get_producer()
>>> producer.produce(['test message ' + str(i ** 2) for i in range(4)]) # 加了个str官方的例子py2.7跑不过

消费者
>>> balanced_consumer = topic.get_balanced_consumer(
    consumer_group='testgroup',
    auto_commit_enable=True,  # 设置为Flase的时候不需要添加 consumer_group
    zookeeper_connect='myZkClusterNode1.com:2181,myZkClusterNode2.com:2181/myZkChroot' # 这里就是连接多个zk
)
