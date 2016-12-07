# rabbitmq 消息队列

## rabbitmq 访问地址
http://localhost:15672/  后台web访问地址

添加 tracing  ,查看消息是否发送过来

1. 登录
2. 在Admin -> Tracing -> Add trace
                            - Name : 11
                            - Format: text
                            - Pattern: #
3. 查看
http://cdn:15672/api/trace-files/11.log

这时,向rabbitmq 发送消息,就可以查看到日志了