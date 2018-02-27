1. consul运行
consul agent -dev -advertise=127.0.0.1

2. 运行server端
go run main.go

3. 运行客户端
go run main.go --run_client

4. 安装micro
go get -v  github.com/micro/micro

4. web界面查看，注册的信息
micro web
localhost:8082

5. api gateway
在 Micro 中，它提供一个单一的入口，它可以被用作反向代理，或者将 HTTP 请求转换成 RPC.
启动：
micro api

curl -d 'service=greeter' \
        -d 'method=Greeter.Hello' \
        -d 'request={"name": "Bob"}' \
        http://localhost:8080/rpc

{"greeting":"Hello Bob"}

6. 列出当前可用的微服务
micro list services