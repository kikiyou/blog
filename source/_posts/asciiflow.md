# ascii 图
```
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


地址：
http://www.asciidraw.com/
http://asciiflow.com/