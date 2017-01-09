# mongodb的使用

## 安装
sudo dnf install mongodb-server.x86_64

启动：
sudo systemctl  start mongod

## 使用
$mongo

+ 查看当前操作的数据库
数据库 切换
use db

> db
test

+ 增
db.runoob.insert({x:10})
第一个命令将数字 10 插入到 runoob 集合的 x 字段中。

db.COLLECTION_NAME.insert(document)

+ 删
>db.col.remove({'title':'MongoDB 教程'})
WriteResult({ "nRemoved" : 2 })           # 删除了两条数据
>db.col.find()
……                                        # 没有数据

+ 改
update() 方法
update() 方法用于更新已存在的文档。语法格式如下：
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
参数说明：
query : update的查询条件，类似sql update查询内where后面的。
update : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的
upsert : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。
multi : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。
writeConcern :可选，抛出异常的级别。

db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}})
save() 方法
db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)
只更新第一条记录：
db.col.update( { "count" : { $gt : 1 } } , { $set : { "test2" : "OK"} } );
全部更新：
db.col.update( { "count" : { $gt : 3 } } , { $set : { "test2" : "OK"} },false,true );
只添加第一条：
db.col.update( { "count" : { $gt : 4 } } , { $set : { "test5" : "OK"} },true,false );
全部添加加进去:
db.col.update( { "count" : { $gt : 5 } } , { $set : { "test5" : "OK"} },true,true );
全部更新：
db.col.update( { "count" : { $gt : 15 } } , { $inc : { "count" : 1} },false,true );
只更新第一条记录：
db.col.update( { "count" : { $gt : 10 } } , { $inc : { "count" : 1} },false,false );




+ 查
runoob 是集合名
> db.runoob.find()
{ "_id" : ObjectId("5871cc462bea47350d13bb2e"), "x" : 10 }
>db.col.find().pretty()
舒服的显示

插入文档你也可以使用 db.col.save(document) 命令。如果不指定 _id 字段 save() 方法类似于 insert() 方法。如果指定 _id 字段，则会更新该 _id 的数据。
+ 创建数据库
> use runoob
switched to db runoob
> db.runoob.insert({"name":"monkey"})
WriteResult({ "nInserted" : 1 })
> show dbs
local   0.078GB
runoob  0.078GB
test    0.078GB

+ 删除数据库
> use runoob
switched to db runoob
> db.dropDatabase()

+ 删除集合
> db.collection.drop()

+ 创建索引
>db.col.ensureIndex({"title":1})


+ 引用式关系
引用式关系是设计数据库时经常用到的方法，这种方法把用户数据文档和用户地址数据文档分开，通过引用文档的 id 字段来建立关系。
{
   "_id":ObjectId("52ffc33cd85242f436000001"),
   "contact": "987654321",
   "dob": "01-01-1991",
   "name": "Tom Benzamin",
   "address_ids": [
      ObjectId("52ffc4a5d85242602e000000"),
      ObjectId("52ffc4a5d85242602e000001")
   ]
}
以上实例中，用户文档的 address_ids 字段包含用户地址的对象id（ObjectId）数组。
我们可以读取这些用户地址的对象id（ObjectId）来获取用户的详细地址信息。
这种方法需要两次查询，第一次查询用户地址的对象id（ObjectId），第二次通过查询的id获取用户的详细地址信息。
>var result = db.users.findOne({"name":"Tom Benzamin"},{"address_ids":1})
>var addresses = db.address.find({"_id":{"$in":result["address_ids"]}})

## 启用web接口

httpinterface = true
rest = true


## 基本概念
SQL术语/概念	MongoDB术语/概念	解释/说明

database	    database	数据库
table	    collection	数据库表/集合
row	    document	数据记录行/文档
column	    field	数据字段/域
index	    index	索引
table   joins	 	表连接,MongoDB不支持
primary key	primary key	主键,MongoDB自动将_id字段设置为主键
数据库服务和客户端
Mysqld/Oracle	    mongod
mysql/sqlplus	    mongo