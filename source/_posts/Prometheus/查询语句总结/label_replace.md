# label_replace

+ label_replace()

label_replace(up{job="api-server",service="a:c"}, "foo", "$1", "service", "(.*):.*")

对于v中的每个时间序列，label_replace（v即时向量，dst_label字符串，替换字符串，src_label字符串，正则表达式字符串）与正则表达式正则表达式匹配标签src_label。 如果匹配，则返回时间序列，并将标签dst_label替换为替换扩展。 $ 1替换为第一个匹配的子组，$ 2替换第二个等等。如果正则表达式不匹配，则时间序列返回不变。


注：
查询时，动态替换字符串