
# aaa 集群环境

+ 整体结构图 
``` shell
                            +                                
        +--------+          |            +------+            
        |  OSS1  |          |            | OSS2 |            
        +---+----+          |            +---+--+            
            |               |                |               
            |               v                |               
            +--keepalive--+ vip +--kippalive-+               
                            |                                
                            |                                
                            +                                
            +-haproxy+---+rabbitmq:5670 +-haproxy-+          
            |               +                     |          
+----------+--------+       |          +----------+---------+
|rabbitmq_node1:5672|       |          |rabbitmq_node2：5672|
+-------------------+       |          +--------------------+
                            v                                
                +------------+-----------+                   
                |      rabbitmq队列       |                   
                +------------+-----------+                   
                            |                                
                            |                                
    keepalive+haproxy       |          keeplaive+haproxy     
                            v                                
            +--------+ AAA_vip:6060+---------+               
            |               +                |               
            |               |                |               
    +-----+-------+         |         +------+-------+       
    |  aaa1:6600  |         |         |  aaa2:6600   |       
    +-------------+         |         +--------------+       
                            |                                
                            v                                
```
+ aaa集群
    
    这里以两机集群演示，4机等类似

    k:keepalive

    h:haproxy
```
           |
         机顶盒
           |
           v
        vip:6060  -> vip 这里是keepalive设置的 virtual ip
          /   \
         /     \
        /       \
aaa1:6600(k+h)  aaa2:6600(k+h)
```

keepalive: 设置vip 每台主机的权值 依次递减，正常情况下vip会一直存在于aaa1 主机

haproxy: 所有主机配置一致，当vip的6060收到请求，会自动转发到aaaX的6600端口

aaa数据库同步:
            每个aaa的数据是独立存放在自己的数据库中，数据来源于rabbitmq，每台主机创建一条唯一的队列，注册到对应exchange

            oss 发广播到 rabbitmq的exchange，各自aaa消费自己对应的队列，把数据入库

这种架构，能保证用户的随机读，也可保证写数据一致，代码中不用区分集群和非集群环境。


+ oss 和 aaa的通信

oss不直接和aaa进行通信,rabbitmp 作为一个消息队列，是传输的中间层
```
       |
      oss
       |
       v
+------+-----+
|rabbitmp队列 |
+------------+
    /   \
   /     \
  /       \
aaa1       aaa2
```

+ aaa 中rabbitmq集群

oss:
    作为消息的生产者
    发广播到指定的oss_exchange

aaa:
    队列创建者：aaa，注入到指定的exchange   消费者：aaa
    创建队列时，会有个partion值，这个一般为主机名，这样就可以n个主机，n条队列，各自消费自己

注：aaa节点机 不需要部署rabbitmq

+ aaa 中rabbitmq集群的高可用
    利用haproxy，侦听 5670， 转发到node：
                            - rabitmq_cluser:5670
                                 - rabitmp_node1:5672
                                 - rabitmp_node2:5672
                                 
   每台rabbitmq主机，都安装haproxy，做这样的配置
   rabbitmq数据同步： rabbitmq集群主机会在各节点间自动同步，rabitmp_node1和rabitmp_node2组建集群即可
