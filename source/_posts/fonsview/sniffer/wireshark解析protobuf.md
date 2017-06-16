# wireshark解析protobuf

解析数据包有两条路：
1. wireshak集成第三方插件解析protobuf

（1）使用 protobuf-wireshark
    [protobuf-wireshark](https://github.com/chrisdew/protobuf-wireshark)
    但是这个项目很久没维护了，只支持对udp数据的查看
    
    国内有人，改写然后支持tcp，介绍在这里：
    http://blog.csdn.net/love_newzai/article/details/8818067

 （2）使用 protobuf_dissector
    项目代码： https://github.com/128technology/protobuf_dissector
    好处：是lua写的 不需要像上面使用 c++的需要编译
    问题：不支持tcp的查看

最终是我上面两种都没选：
(1). 代码是C++写的，看不懂，而且使用还要把wireshark和代码重新编译，对最后能不能用很没谱
(2). 我安装的linux版wireshak默认不支持lua，要用lua需要手动编译wireshak,并且它默认不支持tcp查看

2. 使用python解析数据包
最终选择了这个：
使用pyshark解析数据包，再把其中包含protobuf的二进制数据，传给protobuf-decode进行解析


代码在这里：
https://github.com/kikiyou/pyshark_protobuf
