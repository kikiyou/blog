---
title: es filter
date: 2016-11-03 10:19:44
tags: 
- elk
---
# es filter
<!-- more -->
# 建立测试数据

POST /store/products/_bulk
{"index":{"_id":1}}
{"price":10,"productID":"SD1002110"}
{"index":{"_id":2}}
{"price":20,"productID":"SD1002120"}
{"index":{"_id":3}}
{"price":30,"productID":"SD1002130"}
{"index":{"_id":4}}
{"price":40,"productID":"SD1002140"}

# 查看测试数据
GET /store/products/_mget
{
  "ids":["1","2","3","4"]
}

#-------------------------------------
# 简单过滤查询

# 最简单filter查询
# SELECT * FROM products WHERE price = 20
# filtered 查询价格是20的商品

GET /store/products/_search
{
  "query":{
    "filtered": {
      "query": {
        "match_all": {}
      },
    "filter":{
      "term": {
        "price": "30"
        }
      }
    }
  }
}


GET /store/products/_search
{
  "query":{
    "filtered": {
      "query": {
        "match": {
          "price":20
        }
      },
    "filter":{
      "term": {
        "price": "20"
        }
      }
    }
  }
}

# 查看store的mapping信息

GET /store/_mapping

#在mapping 中锁字段是可以分析的，所以分析后的结果，可
#和你储存的原始结果是有出入的

GET /store/

# 查看分析器解析的结果
GET /_analyze?text=SD1002140



#删除索引 重新建立影射

DELETE /store

PUT /store
{
  "mappings": {
    "products":{
      "properties": {
        "productID":{
          "type":"string",
          "index":"not_analyzed"
        }
      }
    }
  }
}

# bool 过滤查询,可以作做组合过滤查询

# SELECT product FROM products WHERE (price = 20 OR productID = "SD1002120" ) AND (price != 30)

#查询价格等于20的 或者 productID为"SD1002120"的商品,排除价格30元的。

# 类似的,Elasticsearch也有 and, or，not 这样的组合条件
# 的查询方式

# 格式如下：
{
  "bool":{
    "must":[],
    "should":[],
    "must_not":[],
  }
}


# must : 条件必须满足,相当于 and
# should: 条件可以满足也可以不满足,相当于 or
# must_not: 条件不需要满足,相当于 not

GET /store/products/_search
{
  "query":{
    "filtered":{
      "filter":{
        "bool":{
          "should":[
            {"term":{"price":20}},
            {"term":{"productID":"SD1002140"}}
            ],
            "must_not":{
              "term":{"price":30}
            }
        }
      }
    }
  }
}


# 另外一种 and, or， not 查询
# 没有bool， 直接使用 and, or, not

# 查询价格是10元,productID又为SD1002140的结果

GET /store/products/_search
{
  "query":{
    "filtered": {
      "filter": {
        "and":[
        {
          "term":{
            "price":40
          }
        },{
          "term":{
            "productID":"SD1002140"
          }
        }
        ]
      },
      "query":{
        "match_all":{}
      }
    }
  }
}



# range 范围过滤
# SELECT document FROM products WHERE price BETWEEN 20 AND 40

# gt : > 大于
# lt : < 小于
# gte : >= 大于等于
# lte : <= 小于等于

GET /store/products/_search
{
  "query":{
    "filtered":{
      "filter":{
        "range":{
          "price":{
            "gte":20,
            "lte":40
          }
        }
      }
    }
  }
}

## -----------------
## 过滤空和非就空


#建立测试数据

POST /test_index/test/_bulk
{"index":{"_id":"1"}}
{"tags":["search"]}
{"index":{"_id":"2"}}
{"tags":["search","open_source"]}
{"index":{"_id":"3"}}
{"other_field":"some_data"}
{"index":{"_id":"4"}}
{"tags":null}
{"index":{"_id":"5"}}
{"tags":["search",null]}



GET /test_index/test/_search
{
  "query":{
    "filtered":{
      "filter":{
        "exists":{"field":"tags"}
      }
    }
  }
}











