# kafak 简单安装


+ 下载
https://www.apache.org/dyn/closer.cgi?path=/kafka/0.10.2.0/kafka_2.11-0.10.2.0.tgz

+ 解压
tar -xzf kafka_2.11-0.10.2.0.tgz
cd kafka_2.11-0.10.2.0


+ 启动ZooKeeper 服务
> bin/zookeeper-server-start.sh config/zookeeper.properties

+ 启动kafaka服务
> bin/kafka-server-start.sh config/server.properties


+ 创建topic  名字叫:test
> bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test

使用如下命令可以列出topic
> bin/kafka-topics.sh --list --zookeeper localhost:2181
test

+ 插入几条 命令
> bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
直接输入  ，从标准输入读取文件到kafaka


+ 读取kafak中的内容
> bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
