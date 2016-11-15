---
title: redis
date: 2016-07-18 16:10:02
tags: redis
---
## redis 初学
<!-- more -->
+ 字符串
    + 增
        1. SET key value
    + 删
        1. DEL key [key …] 删除键
    + 查
        1. KEYS * 列出K值
        2. GET key 获取V值
+ HASH 操作
    + 增
        1. HSET key field value
        2. HMSET key field value [field value …]
           HMSET 可以很方便的储存字典
           
``` python
import redis
conn = redis.Redis('localhost')

user = {"Name":"Pradeep", "Company":"SCTL", "Address":"Mumbai", "Location":"RCP"}

conn.hmset("pythonDict", user)

conn.hgetall("pythonDict")

{'Company': 'SCTL', 'Address': 'Mumbai', 'Location': 'RCP', 'Name': 'Pradeep'}
```
    + 删
    + 查
        1. HGETALL key
        2. HGET key field
        3. HMGET key field [field …]
    + 只获取字段名或字段值
        HKEYS key
        HVALS key
+ list 类型
    + 增加
        1. LPUSH key value [value …]
        2. RPUSH key value [value …]
        3. LINSERT key BEFORE|AFTER pivot value
            ```
            LINSERT 命令首先会在列表中从左到右查找值为 pivot 的元素，然后根据第二个参数是BEFORE还是AFTER来决定将value插入到该元素的前面还是后面。
            redis> LINSERT numbers AFTER 7 3
            (integer) 4
            ```
         4. RPOPLPUSH source destination 将元素从一个列表转到另一个列表

    + 删除
        1. LPOP key
        2. RPOP key
        3. LREM key count value
        ```
        LREM命令会删除列表中前count个值为value的元素，返回值是实际删除的元素个数。根据count值的不同，LREM命令的执行方式会略有差异。
        （1）当 count > 0时 LREM 命令会从列表左边开始删除前 count 个值为 value的元素。
        （2）当 count < 0时 LREM 命令会从列表右边开始删除前|count|个值为 value 的元素。
        （3）当 count = 0是 LREM命令会删除所有值为 value的元素。
        ```
        4. LTRIM key start end 只保留列表指定片段
    + 查
        1. LLEN numbers
        2. LRANGE key start stop 获取列表片段
        3. LINDEX key index 获得/设置指定索引的元素值
        4. LSET key index value

+ 集合类型
    + 增
        1. SADD key member [member …]
        2. 行集合运算并将结果存储
        ```
        SDIFFSTORE destination key [key …]
        SINTERSTORE destination key [key …]
        SUNIONSTORE destination key [key …]
        ```

    + 删
        1. SREM key member [member …] 删除指定元素
        2. SPOP key 随机选一个元素删除
    + 查
        1. SMEMBERS key 获得集合中的所有元素
        2. SISMEMBER key member 判断元素是否在集合中
        3. SDIFF key [key „] 差集
        4. SINTER key [key „] 交集
        5. SUNION key [key „]  并集
        6. SCARD key 获得集合中元素个数
        7. SRANDMEMBER key [count] 随机获得集合中的元素
+ 有序集合
    + 增
        1. ZADD key score member [score member …] 无增加 有修改
        2. ZINCRBY key increment member 增加某个元素的分数
    + 删
        1. ZREM key member [member …] 删除一个或多个元素
        2. ZREMRANGEBYRANK key start stop 按照排名范围删除元素
        3. ZREMRANGEBYSCORE key min max 按照分数范围删除元素
    + 查
        1. ZSCORE key member 获得元素的分数
        2. ZRANGE key start stop [WITHSCORES] 按照分数列表查找
        3. ZREVRANGE key start stop [WITHSCORES] 查找结果按照分数排列
        4. ZRANGEBYSCORE key min max [WITHSCORES] [LIMIT offset count] 获得指定分数范围的元素
        ```
        如果希望分数范围不包含端点值，可以在分数前加上“(”符号。例如，希望返回”80分到100分的数据，可以含80分，但不包含100分，则稍微修改一下上面的命令即可：
        redis> ZRANGEBYSCORE scoreboard 80 (100
        1) "Tom"
        min和max还支持无穷大，同ZADD命令一样，-inf和+inf分别表示负无穷和正无穷。
        比如你希望得到所有分数高于80分（不包含80分）的人的名单，但你却不知道最高分是多少（虽然有些背离现实，但是为了叙述方便，这里假设可以获得的分数是无上限的），这时就可以用上+inf了：
        redis> ZRANGEBYSCORE scoreboard (80 +inf
        ```
        5. ZCARD key 获得集合中元素的数量
        6. ZCOUNT key min max 获得指定分数范围内的元素个数
        7. ZRANK key member 获得元素的排名

+ 使用
    1. sort来为 集合 列表 排序

+ 发布/订阅 模式
    + 发布者
        1.  PUBLISH channel.1 hi 向频道1发布 hi

    + 订阅者
        1. SUBSCRIBE channel.1 订阅 频道1
```
     写时复制策略也保证了在 fork 的时刻虽然看上去生成了两份内存副本，但实际上内存的占用量并不会增加一倍。这就意味着当系统内存只有2 GB，而Redis数据库的内存有1.5 GB时，执行 fork后内存使用量并不会增加到3 GB（超出物理内存）。为此需要确保 Linux 系统允许应用程序申请超过可用内存（物理内存和交换分区）的空间，方法是在/etc/sysctl.conf 文件加入 vm.overcommit_memory = 1，然后重启系统或者执行 sysctl vm.overcommit_memory=1 确保设置生效。
```
