curl -XGET 'localhost:9200/_cat/health?v&pretty'


可以 查询到集群的  状态 节点数

epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1475871424 16:17:04  elasticsearch green           1         1      5   5    0    0        0             0                  -                100.0%
