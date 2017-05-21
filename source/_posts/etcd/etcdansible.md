使用 etcd 做为 ansible inventory 数据源
发表于2015 年 9 月 23 日
etcd 文档

https://coreos.com/etcd/docs/0.4.7/etcd-api/
https://github.com/oreh/simpletcd

结构

hostvars/12.34.56.78/redis_maxmemory => 4GB
hostvars/12.34.56.78/hostname => abc.jpuyy.com

输出

[abc.jpuyy.com]
12.34.56.78

对应的变量是 redis_maxmemory = 4GB

