# predict_linear 简单线性回归

[参考](https://www.robustperception.io/reduce-noise-from-disk-space-alerts/)
predict_linear 函数，Prometheus中的功能为您提供了一种更智能，更实用的警报。


磁盘空间被占满，是常见磁盘监控，防止这种情况的发生，一般都是使用简单的阈值告警,例如80%,90%或10GB。当所有服务器使用率是按照统一使用率增长时是奏效的，但是有些主机过慢增长，或者过快增长，当收到告警时，可能为时已晚。

如果你想磁盘将在四个小时后填满告警，可以使用predict_linear()
``` yaml
- name: node.rules例子
  rules:
  - alert: DiskWillFillIn4Hours
    expr: predict_linear(node_filesystem_free{job="node"}[1h], 4 * 3600) < 0
    for: 5m
    labels:
      severity: page
```

输入源： node_filesystem_free{job="node"}[1h] 根据一小时内数据来预测未来4小时数据情况
当判断 4小时后，盛誉空间小于0 后进行告警