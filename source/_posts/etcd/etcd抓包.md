# k8s创建 Server过程中与etcd的通信 用到的相关etcd知识点

k8s创建 Server过程中与etcd的通信
1. 获取是否有什么资源配额的设定
GET /v2/keys/registry/resourcequotas/default?quorum=false&recursive=true&sorted=true

quorum=false  

显示的方式表明:非强一致性读，quorum 参数只能用在get请求中，因为只有get操作为了提高性能，允许可能存在非一致性读
注：etcd的思想是 你获取一个过期的数据，比你什么都获取不到好

非一致性读的场景：
etcd node节点和 etcd leader无法通信，这时 请求etcd node get数据，获取的很可能那就是过期的数据（etcd leader中这个数据可能已经被更改了）

recursive=true
递归获取，查看目录及其子目录下面的所有数据

sorted=true
按照createdIndex 排序的方式列出值

2. 从etcd中获取ip段中可用的ip范围
GET /v2/keys/registry/ranges/serviceips?quorum=false&recursive=false&sorted=false  


3. 创建server
PUT /v2/keys/registry/services/specs/default/test?prevExist=false

prevExist=false ，如果key不存在才创建
注： "modifiedIndex":301986,"createdIndex":301986

4. watch service是否真的创建成功了
GET /v2/keys/registry/services/specs?recursive=true&wait=true&waitIndex=301987
注：监控这个目录或后辈目录中index等于301987的事件，如果有则返回一个最接近301987的事件，否则会挂起curl，直到有满足条件的事件发生。

wait=true   客户端会阻塞，只有在key被修改了才会返回
waitIndex=301987

waitIndex 指定了 index，那么
会返回 index 对应的事件，这包含了两种情况：

给出的 index 小于等于etcd中当前 index ，即事件已经发生，那么监听会立即返回该事件
给出的 index 大于当前 index，等待 index 对应的事件发生并返回
目前 etcd 只会保存最近 1000 个事件（整个集群范围内），再早之前的事件会被清理，如果监听被清理的事件会报错。如果出现漏过太多事件（超过 1000）的情况，需要重新获取当然的 index 值（X-Etcd-Index），然后从 X-Etcd-Index+1 开始监听。


etcd 中一致性的保证：
比如有 有两台主机 node1 node2

node1  get version  ->    modifiedIndex":10001
node1  get version  ->    modifiedIndex":10001

node1  put version prevIndex=10001      put成功   modifiedIndex现在变为10002
node2  put version prevIndex=10001      这时node2会失败 报错内容如下
{"errorCode":101,"message":"Compare failed","cause":"[10001 != 10002]","index":10002}
