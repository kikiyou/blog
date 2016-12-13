# ansible 开发模式

使用环境变量指定参数，让ansible在指定目录运行

1. 下载ansible 源码
git clone ansible

2. 引入环境变量
source ./hacking/env-setup

3. 查看自己的环境
which ansible

可以看到 ansible 是自己的环境

4. 使用test-module 运行 自定义 mode

python  ./hacking/test-module ./library/command /bin/sleep 3

