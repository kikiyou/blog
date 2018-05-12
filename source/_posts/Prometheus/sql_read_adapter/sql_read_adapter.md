# sql_read_adapter

https://www.robustperception.io/promql-queries-against-sql-databases-using-a-read-adapter/


{query="select baz, bar, value from foo",job="sql"}

{query="select *  from foo where bar=\"eee\"",job="sql"}
支持 从sql数据库中，导入数据到prometheus 并支持如上的sql查询语句。

是把查询数据，转发带给sql_read_adapter，然后由sql_read_adapter执行查询，并把结果返回给prometheus，
prometheus不进行真正的数据存储。


远程写：
https://github.com/prometheus/prometheus/blob/master/documentation/examples/remote_storage/example_write_adapter/server.go