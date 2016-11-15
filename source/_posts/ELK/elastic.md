---
title: Elasticsearch
date: 2016-10-10 10:19:44
tags: 
- elk
---
# Elasticsearch
<!-- more -->
Elasticsearch 2.4.1
26MB 小巧好用

elasticsearch 中索引相当于database
数据清除办法
``` bash
curl -XDELETE 'http://127.0.0.1:9200/logstash-2013.03.*' 
```

* Elasticsearch 与 关系型数据库 名称对比

  |关系型数据库|elasticsearch|
  |----------|:-------------:|
  | database |  index       | 
  | table    |  type        |
  | row      | document     |
  | column   | field        |
  | row      | document     |
  | schema   | mapping      |
  | index    | （全部）       |
  | sql      | query DSL    |

* elastic 存储数据的路径：

/var/lib/elasticsearch/nodes/0/indices/{nameOfYourIndex}/(0-4}/index

* 增加

``` bash
curl -XPOST 'http://localhost:9200/index_XX/type_XX/1' -d '{
countent: "大家好"
user_name: "fox"
}'
```
* 删除

``` bash
curl -XDELETE 'http://localhost:9200/index_XX/type_XX/1' 
```

* 修改

``` bash
curl -XPUT 'http://localhost:9200/index_XX/type_XX/1' -d '{
countent: "大家好"
user_name: "foo"
}'

POST /inde_XXX/type_XXX/_update     //使用_update字段更新
{
  "doc":{
    "price":10
  }
}

```
* 查询

``` bash
curl -XGET 'http://localhost:9200/index_XX/type_XX/1'

  _source 获取字段
  curl -XGET 'http://localhost:9200/_source=uid'

GET  _all/_settings  //获取所有索引的设置
GET  logstash-v5-coins-2016.11.01/_settings  //获取单个索引的设置
{
  "logstash-v5-coins-2016.11.01": {
    "settings": {
      "index": {
        "creation_date": "1477958402595",
        "refresh_interval": "5s",
        "number_of_shards": "5",   //定义索引的主分片数量 创建索引后不可修改
        "number_of_replicas": "1", //每个主分片的复制分片个数，默认1 可修改
        "uuid": "7QwiwQ4KQcmSiLUnALR6ZA",
        "version": {
          "created": "2040199"
        }
      }
    }
  }
}
```

* 搜索

``` bash
全局搜索：
curl -XGET 'http://localhost:9200/_search?q=uid:10002827'

简单搜索
curl -XGET 'http://localhost:9200/logstash-v5-equipment-2016.10.25/v5-equipment/_search?q=uid:10002827'

* TERM - 关键词
curl -XGET "http://localhost:9200/_search" -d'{
  "query": {
    "term": {
      "user": "fox"
    }
  }
}'

* TEXT
{
  "query": {
    "text": {
      "countent": "这样那样" //会自动分割成term 这样 样那 那样
    }
  }
}

* RANGE
// 查看一个范围
{
  "query" :{
    "range" :{
      "age":{
        "from" : 10,
        "to" : 20,
        "include_lower": true,
        "include_upper":false,
        "boost" :2.0
      }
    }
  }
} 

* QUERY_STRING
{
  "query":{
    "query_string":{
      "query":" 这样 AND 那样 OR 怎样"
    }
  }
}

* WILDCARD - 通配符
{
  "query":{
    "wildcard":{"user" : "ki*y"}
  }
}

* MLT(more like this)
{
  "query":{
    "more_like_this":{
      "like_text": "这样那样",
      "min_term_freq": 1,   //关键词出现的频率
      "max_query_term": 12 
    }
  }
}

*  FACETS - 切面

  + aggregation 聚合
  + SELECT SUM(salary) GROUP BY name FROM employee;

facets  支持以下,就像sql group中支持 sum max 等
  + range
  + term status   //统计term出现的次数
  + geo distance
  + statistical //统计上的平均值 最大 最小
  + date histogram //时间分片


//查询频率最高的
{
  "query":{
    "match_all":{}
  },
  "facets":{  //分组 相当于sql 中group
    "bpmf":{  //组名
      "terms":{
        "field" : "bopomofo"
      }
    }
  }
}
// 查询频率最高的内容
{
  "query":{
    "match_all":{}
  },
  "facets":{
    "top":{
      "terms":{
        "filed": "countent","size": 100 // 前一百笔
              }
    }
  }
}

```
+ 组合查询
  + bool查询
    - must,should,must_not   与/或/非
    - minimum_should_match: 表示一个文档至少匹配多少个短语才算时匹配
    - disable_coord: 启用和禁用一个文档中包含所有查询关键词的分数得分计算,默认是false
  + boosting查询
    - positive部分：查询返回的查询结果分值不变
    - negative部分：查询的结果分值会被降低
    - negative_boost部分：设置negative中要降低的分值
  + constant_score查询 
    - 优点：可以让一个查询得到一个恒定的分值
  + indices查询 -> 在多个索引里面查询
    - no_match_query 查询其他索引里的数据

+ Filter 过滤 （有cache）
  + filter 查询语句
  + cache 缓存
    开启方式:在filter查询语句后面加"_cache":true
    注意：
    Script filters,Geo-filters,Date ranges 这样的过滤方式开启cache无意义
    exits,missing,range,term和terms查询是默认开启cache的

+ bulk 批量操作
{action:{metadata}}\n
{request body}\n
{action:{metadata}}\n
{request body}\n
...

例:{"delete":{"_index":"library","_type":"books","_id":"1"}}

| action(行为)  | 解释                     |
|--------------:|--------------------------|
| create        | 当文件不存在时创建之。   |
| index         | 创建新文档或替换已有文档 |
| update        | 局部更新文档             |
| delete        | 删除一个文档             |

+ Elasticsearch 版本控制version  --》 锁  --》 悲观锁/乐观锁
  + 内部版本控制：_version自增长,修改数据后，_version会自动加1
  + 外部版本控制：为了保持_version与外部版本控制的数值一致，使用version_type=external,
                检查数据当前的version值 是否小于请求中的version值 
``` bash
PUT  twitter/books/1
{
  "title":"eeeeeeeeee title eeeeeeeeeeeee",
  "name":{
    "first":"Zachary",
    "last":"Tong"
  },
  "publish_data":"2015-02-06",
  "price":"59.99"
}


get twitter/books/1

post /twitter/books/1/_update?version=333  //内部版本控制，指定外部版号为333， 会提示冲突
{
  "doc":{
    "price":11
  }
}

外部版本控制机制,指定的version=5 大于当前版本就ok
version 由外部提供
PUT /twitter/books/1?version=5&version_type=external
{
  "title":"ttttt 3333 ttt",
  "name":{
    "first":"cccc",
    "last":"Tang"
  }
}

```

+ cluster
  + auto-discovery
  + auto-elected master
  + data replication / partition
    + with flexible shard /replica setting
     
+ shard  相当于 mysql 中 partition
  是介于 database 和 document之间  ，一个database 包括多个shard
  + more shard 
    + faster indexing / scaling

+ replica 相当于 mysql的 duplication
  + faster searching / failover

+ stats api

[stats api文档](http://www.elasticsearch.org/guide/reference/api/admin-cluster-nodes-stats)

+ 取得各项数据
+ 文件数、搜索次数、累计搜索时数、累计建索引时间
  + cluster/primary/node/index 各种级别
+ JVM CPU/Heap / OS /Thread /transport 使用状态

参考：
[Cool Bonsai Cool - An introduction to ElasticSearch](http://bit.ly/112xtsk)
[The Road to a Distributed Search Engine](http://bit.ly/ZqBBUt)
[elasticsearch, Big Data, Search & Analytics](http://bit.ly/11tmbyK)

+ 数据备份

使用elasticdump
``` bash
导出：
具体data配置信息
elasticdump --ignore-errors=true  --scrollTime=120m  --bulk=true --input=http://xxxxx:9200/.kibana   --output=data.json  --type=data
导出mapping信息
elasticdump --ignore-errors=true  --scrollTime=120m  --bulk=true --input=http://xxxxxx/.kibana   --output=mapping.json  --type=mapping  

导入：

导入mapping
elasticdump --input=mapping.json  --output=http://xxxxxxx:9000/.kibana --type=mapping

导入具体的kibana配置信息
elasticdump --input=data.json  --output=http://xxxxx:9000/.kibana --type=data
```

参考：
[Elasticsearch 2.20入门篇：聚合操作](https://my.oschina.net/secisland/blog/614127)
[Elasticsearch 的聚合查询及过滤](http://techlog.cn/article/list/10182851)