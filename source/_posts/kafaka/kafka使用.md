cdn-viewlog-hls
cdn-viewlog-pc

bin/kafka-topics.sh --zookeeper localhost:2181 --list

bin/kafka-console-consumer.sh --zookeeper localhost:2181 --from-beginning --topic cdn-viewlog-hls