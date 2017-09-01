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