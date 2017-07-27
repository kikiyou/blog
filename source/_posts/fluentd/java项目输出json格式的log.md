# java项目输出log格式为json的方法

为方便ELK 日志分析使用，需要把log文件格式输出为json

可以使用 logstash 官方推出的 JSON layout
https://github.com/logstash/log4j-jsonevent-layout

maven配置，如下：
<dependency>
    <groupId>net.logstash.log4j</groupId>
    <artifactId>jsonevent-layout</artifactId>
    <version>1.7</version>  
</dependency>

jar包下载地址：
[jsonevent-layout-1.7.jar](http://maven.aliyun.com/nexus/service/local/repositories/central/content/net/logstash/log4j/jsonevent-layout/1.7/jsonevent-layout-1.7.jar)

jsonevent-layout依赖包文件：
[log4j:1.2.17](http://maven.aliyun.com/nexus/service/local/repositories/hongkong-nexus/content/log4j/log4j/1.2.17/log4j-1.2.17.jar)

[json-smart:1.1.1](http://maven.aliyun.com/nexus/service/local/repositories/central/content/net/minidev/json-smart/1.1.1/json-smart-1.1.1.jar)

[commons-lang:2.6](http://maven.aliyun.com/nexus/service/local/repositories/central/content/commons-lang/commons-lang/2.6/commons-lang-2.6.jar)


测试代码，和log4j配置请看附件：
Test.java
log4j.properties


输出的log格式如下，包含stacktrace：
``` json
{
    "exception": {
        "stacktrace": "java.lang.RuntimeException: ao\n\tat com.monkey.Test.main(Test.java:22)",
        "exception_class": "java.lang.RuntimeException",
        "exception_message": "ao"
    },
    "source_host": "monkey.fonsview.com",
    "method": "main",
    "level": "ERROR",
    "message": "exception:[{}]",
    "mdc": {},
    "@timestamp": "2017-07-25T15:53:50.667Z",
    "file": "Test.java",
    "line_number": "22",
    "thread_name": "main",
    "@version": 1,
    "logger_name": "root",
    "class": "monkey.Test"
}
```
[jsonevent-layout依赖参考](http://book2s.com/java/jar/j/jsonevent-layout/download-jsonevent-layout-1.7.html)