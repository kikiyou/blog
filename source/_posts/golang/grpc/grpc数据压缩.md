# grpc 数据压缩


server端 你只需要import  gzip 包 同时 它的init函数自动注册

import _ "google.golang.org/grpc/encoding/gzip"

客户端:
import "google.golang.org/grpc/encoding/gzip"

...

conn, err := grpc.Dial(addr, grpc.WithDefaultCallOptions(grpc.UseCompressor(gzip.Name)))


如上即可工作，实现grpc 传输数据的压缩与解压