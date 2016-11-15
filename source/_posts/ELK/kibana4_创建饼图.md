---
title: kibana4 创建饼图
date: 2016-10-30 11:31:44
tags: 
- elk
---
# kibana4 创建饼图
<!-- more -->

1. Visualize -> Pie Chart -> From a new search
2. 选中需要做图的索引 比如：logstash-lighttpd-access-*
3. Slice Size（分片值） 选Count
4. 在Select buckets type 中选 Split Slices（分割分片）
5. Aggregation（聚合）中选 Terms 
6. 在Fidld 中选response.raw  order by中选 metric（度量）：Count
7. order (排序) --> 中有两个选项  Descending（降序）Ascending（升序）
8. size 是 中的值  相当于 sql 中的 limit
9. 在右边中200  404 等值 点击 可以选颜色
10. 点击下面的 V 符号，可以选 Table Request  Response Statistics
11. 设计好了之后，点击右边 保存，可把这张图保存起来