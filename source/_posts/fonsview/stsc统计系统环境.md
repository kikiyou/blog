# stsc 统计系统环境

+ 整体结构图 
```
        +-------+
        | ss log|
        +---+---+
            | ftp
        +---+---+
        |  omc  |
        +---+---+                  +---+            +----+
            |  ftp 下载            |cms |            |oss |
            |  viewlog             +---+            +---++
        +---+---+                    |   日志加工转换    |
        | flume |                    |    +-------+    |
        +---+---+                    +--->+ stdm  +<---+
            | 把viewlog内容                +-+-+---+
            | 传给topic，cdn-viewlog-pc      ^ |
+-----------+------------+    读,           | |
|                        | -----------------+  |
|      kafaka            | <------------------+
+---------+--------------+    写，cdn-viewlog-pc-stsc
          |
          |读 cdn-viewlog-pc-stsc
          |
    +-----v-------+
    | fsvlogstash |
    +-----+-------+
          | 9300端口
    +-----v-------+   +-------------+    +-------------+
    |elasticsearch|---|elasticsearch|----|elasticsearch|---。。。。。。
    +-----+-------+   +-------------+    +-------------+
          |
    +-----v-----+
    |   stsc    |
    +-----+-----+
          |
    +-----v------+
    |stsc reports|
    +-----+------+
          |
      鉴权 | 单点登录
+---+   +--v--+     +---+
|oss+---+ cas +---->+cms|
+---+   +---+-+     +---+
          | 
          |
+---------v----------+
|   喜闻乐见的图形界面   |
+--------------------+
```

+ stsc 主要流程
1. ss 生成log，并通过ftp的方式传送到omc
2. 把omc中的log，下载到flume主机上
3. flume解析 ss的log之后，把log内容传送到kafka里指定的topic中，比如 cdn-viewlog-pc
4. stdm 从 kafka 中读取 未加工过的log，比如： 读取 cdn-viewlog-pc
5. stdm 根据同步到的cms oss中的数据，和 cdn-viewlog-pc中的log，生成转换后数据。
6. stdm 把转换后数据，传送到 kafka 里的  cdn-viewlog-pc-stsc 中。 注：转换后数据有后缀 stsc
7. fsvlogstash 读取 cdn-viewlog-pc-stsc 中的内容 存入 elasticsearch 数据库集群中。
8. 