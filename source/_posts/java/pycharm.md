# pycharm的使用

+ 快捷键

Alt + F  快速新建文件

Ctrl + Alt + T 插入 判断等 (自动创建注释等)

Shift + F10 是运行程序
shift + F9 调试运行
F9  移动到下一个断点
F8  步进调试



Alt + Shift + E 执行选中的代码

+ 指定一个定时器
打开 setting -> Tools -> Python Integrated Tools
学 Default test runner -> Nosetests


+ 可以给代码设置断点
右键断点处，可以给断点修改断点属性 
condition 给断点加条件


+ 　　当需要输入HTML类型标签时，PyCharm同样设计了帮助系统：

　　Ctrl+Space调用拼写提示功能。

　　当输入一个括号时，会自动生成另一个括号以进行匹配

+ pycharm 的database 可以直接连接 数据库 很方便

+ 自动导入

 比如写 time.sleep(10)  时忘记先import time 的话，可以Alt + Enter 自动导入

 + file watcher 监控文件的改变
 如果文件发生改变 就调用指定的命令 

使用场景：
index.jade  如果改变 调用pyjade 生成对应的jinja或html页面
index.less  如果改变 调用less 生成对应的css文件

+ 创建便签注释

# todo  注释  