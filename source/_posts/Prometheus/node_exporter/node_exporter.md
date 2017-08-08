#node_exporter 代码学习

+ 标准库—命令行参数解析flag
``` listenAddress = flag.String("web.listen-address", ":9100", "Address on which to expose metrics and web interface.") ```
变量名  类型 （参数 默认变量 简短说明）

``` golang
package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	var (
		showVersion   = flag.Bool("version", false, "Print version information.")
		listenAddress = flag.String("web.listen-address", ":9100", "Address on which to expose metrics and web interface.")
	)
	flag.Parse()
	if *showVersion {
		fmt.Fprintln(os.Stdout, "version_0.01")
		os.Exit(0)
	}
	fmt.Println(*listenAddress)
}
```

+ prometheus 代码主逻辑

1. 初始化注册 启用默认的数据收集
func init() {
	prometheus.MustRegister(version.NewCollector("node_exporter"))
}

2. 如果启用非默认启用的监控 使用如下方法传参
``` bash
./node_exporter -collectors.enabled=netstat,netdev

enabledCollectors = flag.String("collectors.enabled", filterAvailableCollectors(defaultCollectors), "Comma-separated list of collectors to use.")

collectors, err := loadCollectors(*enabledCollectors)
nodeCollector := NodeCollector{collectors: collectors}
prometheus.MustRegister(nodeCollector)

``` 


go项目依赖管理：
下载：
go get -u -v github.com/kardianos/govendor


执行一下命令就可以生成 vendor 文件夹：
$ govendor init
$ ls
main.go    vendor
$ cd vendor/
$ ls
vendor.json
这个

+ prometheus的数据类型
[Prometheus的基本数据类型](http://yunlzheng.github.io/2017/07/07/prometheus-exporter-example-go/)

Counter计数器  ---> uptime 等只增不减

Gauge仪表盘    --> 有增有减，比如当前负载等

Histogram柱状图
Summary概要


+ loadavg负载情况

type loadavgCollector struct {
	metric []prometheus.Gauge
}


定了一个类型loadavgCollector，里面有属性metric是个数组，数组中存的是prometheus.Gauge类型的数据
``` bash
创建一个prometheus registry 并返回一个新的收集器，来暴露平均负载数据
// Take a prometheus registry and return a new Collector exposing load average.
func NewLoadavgCollector() (Collector, error) {
	return &loadavgCollector{
		metric: []prometheus.Gauge{
			prometheus.NewGauge(prometheus.GaugeOpts{
				Namespace: Namespace,
				Name:      "load1",
				Help:      "1m load average.",
			}),
			prometheus.NewGauge(prometheus.GaugeOpts{
				Namespace: Namespace,
				Name:      "load5",
				Help:      "5m load average.",
			}),
			prometheus.NewGauge(prometheus.GaugeOpts{
				Namespace: Namespace,
				Name:      "load15",
				Help:      "15m load average.",
			}),
		},
	}, nil
}

数组初始化:
[5] int {1,2,3,4,5}
``` 
上面的代码：
1. 数组  []prometheus.Gauge 初始化
2. 把结构 loadavgCollector 初始化赋值
//定义一个struct  
type Student struct {  
    id      int  
    name    string  
    address string  
    age     int  
}  

var s3 *Student = &Student{id: 104, name: "Lancy"}


+ 
Namespace string
Subsystem string
Name      string   -- 必填
Help string        -- 必填
ConstLabels Labels

其中，Namespace是监控前面的
const Namespace = "node"
node_exporter_scrape_duration_seconds{collector="netdev",result="success",quantile="0.5"} 0.000907935

比如：
const Namespace = "node99999"
node99999_exporter_scrape_duration_seconds{collector="netdev",result="success",quantile="0.5"} 0.000907935

如下是导出的数据：
# HELP node_load1 1m load average.
# TYPE node_load1 gauge
node_load1 0.38
# HELP node_load15 15m load average.
# TYPE node_load15 gauge
node_load15 0.29
# HELP node_load5 5m load average.
# TYPE node_load5 gauge
node_load5 0.35

其中：
Namespace: "node",
Name:      "load1",
Help:      "1m load average.",


触发方式是server 每次pull一次，收集一次

+ go中路径处理模块
path.Join("/proc", "loadavg")
/proc/loadavg



+ 数据传递
c.metric[i].Set(load)
c.metric[i].Collect(ch)


+ 数据流程
init 初始化，定结构，update 附加新值


+ go方法的定义
func (c *loadavgCollector) Update(ch chan<- prometheus.Metric) (err error) {
