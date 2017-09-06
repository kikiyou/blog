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