## ansible lookup 模块可以直接调用自己写的模块

具体可参考这里：
https://github.com/ansible/lightbulb/tree/master/workshops/developer/lookup_plugins

这个方法 只在ansible2 中可用


自己可以写本地的模块，在ansible中调用自定义的本地模块，可以把本地的值传给远程