1. ttl原理：
在etcd中 带有ttl的 key/value 是使用heap来记录相应的信息
type store struct {
	Root           *node
	WatcherHub     *watcherHub
	CurrentIndex   uint64
	Stats          *Stats
	CurrentVersion int
	ttlKeyHeap     *ttlKeyHeap  // need to recovery manually
	worldLock      sync.RWMutex // stop the world lock
	clock          clockwork.Clock
	readonlySet    types.Set
}

// TTLKeyHeap  是一个 按照TTLKeys的失效时间排列的min-heap
type ttlKeyHeap struct {
	array  []*node
	keyMap map[*node]int
}

2. 时间同步对etcd的影响：
注：ttl这个概念在v3中被删除，取而代之的是租约

    （1）.  当我们使用下面的命令 设置带有ttl的key时
               curl http://127.0.0.1:2379/v2/keys/foo -XPUT -d value=bar -d ttl=5
    （2）. 所有的set 都会转发给master
        master 生成个失效时间：
        失效时间 = master当前时间 + tll

        再由master 把 key ， value ，失效时间 发给各个节点

    （3）. 关于过期key的删除
        etcd早期版本： key是由node自己控制，当发现存在失效时间的key时，启一个线程，循环检测，如果过期 就删除  （缺点：如果node的时间不准，key会过早删除）

        2.x的后期版本：
        key的删除 由master控制，master会有个定期的sync 下发master的当前时间 来执行DeleteExpiredKeys（删除过期key）

            缺点： 
            1. 当节点同master断开连接后，过期的key不会被删除  （收不到来自master的sync指令）

            2. 极端情况下，依然会出现key过早的被删除 （两个条件 1.主机时间不一致 2.两台主机发生主从切换）
            场景如下：
            当monkey1 主机 和 monkey2主机 都是etcd集群，并且时间不一致
            monkey1 是master主机 会定期 发送sync指令控制过期key的删除，这时没有问题
            但是，当发生主从切换，monkey2主机变成master之后，monkey2发送同步指令删除过期key，这时key就有可能会被过早的删除

            注：这种极端情况的处理，在v3中被 使用租约的方式被解决，当发生主从切换之后，会重新计数 refresh 失效日期
            [github上对这一问题的说明](https://github.com/coreos/etcd/issues/2660)

3. k8s使用了etcd的哪些功能:
Get
Set
Update
CompareAndSwap
Delete
Watch
（暂时没有发现 k8s中用到etcd的ttl）

4. k8s哪些组件同ETCD有交互:
只有api server和etcd集群直接交互
calico作为第三方组件，会把配置与ip信息 存放在etcd中