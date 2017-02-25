
[参考-zabbix 图像显示 Grafana](http://qkxue.net/info/188153/zabbix-Grafana)
[如何在CentOS 7的Zabbix中安装和配置Grafana绘制漂亮的图表](https://www.howtoing.com/how-to-install-and-configure-grafana-to-plot-beautiful-graphs-from-zabbix-on-centos-7/)

1. grafana

+ 下载
docker run -d --name=grafana-xxl -p 3000:3000 monitoringartist/grafana-xxl:latest


+ 运行：
docker run -d -v /var/lib/grafana --name grafana-xxl-storage busybox:latest


docker run \
  -d \
  -p 3000:3000 \
  --name grafana-xxl \
  --volumes-from grafana-xxl-storage \
  monitoringartist/grafana-xxl:latest


+ 添加zabbix监控
0. 把zabbix enable
1. Data Source --> Add data source -->

Name zabbix   Default 选中
Type zabbix
Url http://xxxxx/zabbix/api_jsonrpc.php
zabbix api details
username Admin
Password zabbix
Trends enable


+ 添加图形

0. ADD ROW  选 Graph
1. 左键上标题栏   选择 edite
2. Metrics(度量) 中 Panel data source(面板数据源)这里选择zabbix
3. Metrics中 
   Group 填入 $group   Host 填入 $host
   Application 空      Item 填入 网卡
4. 如果想把 出和入两个流量合并  可以再选择  Add query添加一栏 或者 右边选项里面选复制


+ 导出vsv 所有图片，选右键 选项这里可以导出到csv


+ 添加报警
0. 选择一副图 左键上标题栏   选择 edite 
1. 选择Alert  name选项 配置名字  Evaluate every（评估时间）60s
2. 条件 when avg() of  （查询A ，5分钟，到现在） 
   is above（以上）
   is below（以下）
   IS OUTSIDE RANGE（除此之外）
   IS WITHIN RANGE（在这个范围之内）
   HAS NO VALUE(没有值)

   SET STATE TO 当达到触发条件之后，把状态改为ok 或报警


编辑菜单中各选项

1. General
info（信息）
Title（标题）
Description（描述）

Dimensions（尺度）
Span（宽）
Height(高)
Transparent（透明）

Templating（模板）
Repeat Panel（复制面板）
Min span（最小宽度）

2. Metrics（度量，规律）

3. Axes（轴，x或y轴）
Unit （这里设置数据的单位）

4. Legend（铭文）
定义汇总信息是在右边还是下面，汇总信息 包括 最大 最小 平均 当前

5. Display(图形展示)
Series  overrides  这里可以设定，把进流量,变到下面显示
0. 添加 override
alias or regex   /Incoming/   Transform: negative-Y （改变为负数在y轴）


6. Alert（报警）

7. 时间范围


右上角设置选模板，可以设置变量

$group	*
$host	$group.*
$netif	*.$host.Network interfaces.*


说明，选ss的进流量 和 出流量进行对比，ss的进流量是 调度器访问所以比较平均，但是出流是就是有变化的，说明出流量是给客户的


+  添加饼图  
在添加图形搜索中搜索  pie
0. Metrics 中添加两个选项 一个是 总磁盘使用情况  另一个是当前磁盘使用情况
1. 在Options 设置这里   选legend（铭文）
   可以显示 占用百分比等

+ Singlestat 单值 状态面板
选择 启用Gauge  可以达到 显示汽车仪表盘的功能