
* 只返回指定的字段
## 查询
 1. 使用 _source
GET /logstash-v5-equipment-2016.11.03/v5-equipment/_search
{
   "_source": {
    "include": ["uid"]
    },
   "query":{
    "filtered":{
      "filter":{
        "match":{"code":"ZhiZunBaoXiang"}
      }
    }
  } 
}


 2. 使用fields 字段
GET /logstash-v5-equipment-2016.11.03/v5-equipment/_search
{
   "fields": ["uid"],
   "query":{
    "filtered":{
      "filter":{
        "match":{"code":"ZhiZunBaoXiang"}
      }
    }
  } 
}


Elasticsearch Query DSL、Facets、Aggs学习困惑。

有人为此开发了使用SQL执行ES Query的插件，一定程度上减轻了进入门槛。
我们给出的学习他们的建议是观察Kibana的Request Body或试用Marvel的Senese插件，它有自动完成Query、Facets、Aggs的功能。另外最常用的query是query string query，最常用的aggs是Terms、Date Histogram，可以应付大部分需求。