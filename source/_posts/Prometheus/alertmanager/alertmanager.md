#alertmanager 告警管理

aggregation 聚合
dispatcher 调度员
event 事件
matcher 匹配
suppression 抑制



1. 手动静默告警
2. 基于依赖关系的告警抑制
3. 通过告警标签的告警聚合
4. 处理告警重复通知
5. 通过外部服务发送警报通知




type Suppression struct {
	Id uint

	Description string

	Filters *Filters

	EndsAt time.Time

	CreatedBy string
	CreatedAt time.Time
}


实现堆 需要实现,Len Less Swap Push Pop,这五个方法


1. 创建一个以Suppression 堆为结构的堆，依EndsAt为排序依据的小堆


	suppressor := manager.NewSuppressor()
// 创建一个新的抑制器，并初始化一个堆结构，并创建了三个频道
	defer suppressor.Close()

    go suppressor.Dispatch()
// 创建调度器方法


调度器方法，是一个for 循环的select，应该使用创建一个最小的占用期的计数器，来更只能的完成这个任务


reapSuppressions（） 方法，计算数组Suppressions的长度，
因为数组结构Suppressions，实现了Len()，Less(),Swap() 方法，所以可以使用sort排序

小堆，以时间排列，小的数在前面，比如[1,2,3,4,5],After() 方法，比如After(3),就获得了4的下标,使用如下方法，把以前的数据都清除
*s.Suppressions = (*s.Suppressions)[i:]

使用Init重新排序：	
heap.Init(s.Suppressions)

-alertmanager.url http://localhost:9093

查询静默 匹配规则
if f.Name.MatchString(k) && f.Value.MatchString(v) {
    return true



	summarizer := manager.NewSummaryDispatcher()
	go aggregator.Dispatch(summarizer)
	log.Println("Done.")



汇总 也有过滤规则和重复时间
type AggregationRule struct {
	Filters Filters

	RepeatRate time.Duration
}



看到了这里：
SHA ba224785
by Julius Volz, 07/23/2013 04:40 PM
parent 00efa4a4

+ 添加告警支持

在notifier.go中添加如下代码，会自动搜索配置文件，如果配置文件中flowdock_config的配置，就会自动套用flowdock_config的配置，发送告警信息到flowdock


for _, fdConfig := range config.FlowdockConfig {
    if op == notificationOpResolve && !fdConfig.GetSendResolved() {
        continue
    }
    flowdockMessage := getFlowdockNotificationMessage(op, fdConfig, a)
    url := *flowdockURL + "/" + fdConfig.GetApiToken()
    httpResponse := postJSONtoURL(jsonize(flowdockMessage), url)
    processResponse(httpResponse, "Flowdock", a)
}



alertmanager 使用fsnotify 来监控文件，如果文件发生了变更会触发事件
[使用go-fsnotify文件监控工具](http://lihaoquan.me/2015/9/1/using-fsnotity.html)



alertmanager的黑科技，把静态文件编译进二进制代码中


看完了 0.0.3

+ api 增加一个接口的

func (s AlertManagerService) Handler() http.Handler {
	r := httprouter.New()
	r.GET(s.PathPrefix+"api/alerts", s.getAlerts)
}

就像上面r.GET(),接口地址s.PathPrefix+"api/alerts 对应的方法s.getAlerts，实现个getAlerts方法即可


有静默文件的时候 读取，没有的自己创建一个


状态有两个 firing  和  resolved


调度器，每次休眠30s，循环，
如果s.suppressionReqs 通道有值就调度到 s.dispatchSuppression(suppression) 方法





	i := sort.Search(len(*s.Suppressions), func(i int) bool {
		return (*s.Suppressions)[i].EndsAt.After(t)
	})

	*s.Suppressions = (*s.Suppressions)[i:]


在什么，之后


30s 一聚合，把超过30s 前的数据会丢弃
下面。三个任意两个有数据，就会推出
s.dispatchSuppression(suppression)
调度抑制
s.queryInhibit(query)
查询抑制
s.generateSummary(summary)
一般汇总

type Filter struct {
	Name  *regexp.Regexp
	Value *regexp.Regexp

	fingerprint uint64
}


+ 全局配置里面的ResolveTimeout，就是如果多长世界内没有再次收到告警消息，自多发生告警恢复消息

+ alertmanager 自己为模板注册了一些函数

``` golang
var DefaultFuncs = FuncMap{
	"toUpper": strings.ToUpper,
	"toLower": strings.ToLower,
	"title":   strings.Title,
	// join is equal to strings.Join but inverts the argument order
	// for easier pipelining in templates.
	"join": func(sep string, s []string) string {
		return strings.Join(s, sep)
	},
}
```