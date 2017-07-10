#fluentd 安装使用
http://7xw819.com1.z0.glb.clouddn.com/td-agent-2.3.5-1.el2017.x86_64.rpm


fluentd配置指令

1. source 输入：数据来源于哪里
2. match 输出：告诉fluentd干什么
3. filter 过滤:事件处理流水线
4. system 设定system层扩展
5. label 加标签
6. @include 包括其他文件


curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test