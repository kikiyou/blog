# ansible raw 模块

ansible 需要客户端 至少要有python-json 这个包依赖，但是如果你想批量安装这个包怎么办

可以使用raw 模块，raw模块和command模块基本一样，只是不需要python依赖，可以给一些交换机 等批量发命令


用法如下:

# Bootstrap a legacy python 2.4 host
- raw: yum -y install python-simplejson
