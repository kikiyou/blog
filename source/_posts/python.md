---
title: python学习
date: 2016-07-14 10:19:44
tags: python
---

### python学习
<!-- more -->
python debug 工具
    pdb
    (https://docs.python.org/2/library/pdb.html)
    
[常用的标准库](https://www.zhihu.com/question/20501628)

vs code 直接输出python
http://stackoverflow.com/questions/29987840/how-to-execute-python-code-from-within-visual-studio-code

+ python 默认就有 __setattr__ 和 __getattr__方法
  可以方便的对属性赋值  而不用写set 和 get 方法

+ 动态添加属性 和 方法
  1. 属性
    obj.a = 1或setattr(obj, 'a', 1)
  2. 方法
      class A(object):
        pass
      
      a = A(object)
     (1) a.hello = types.MethodType(a, hello)
     (2) 方法二  如下
          ```
          class Student(object):
              pass
          s = Student()
          def hello():
              print "hello word!!!"

          s.hello = hello
          s.hello()
          ```
3. @property  把方法变成属性

+ python 中闭包的实现
  ```
  def addx(x):
    return lambda y: x + y

  add8 = addx(8)
  add9 = addx(9)

  print add8(100)
  print add9(100)

  闭包的作用

  加强模块化

```
+ locals() 和 globals()
  局部命名空间 和 全局命名空间

  python中namespace只是一个字典，它的键字就是变量名，字典的值就是那些变量的值。
 
 locals 是只读的，globals 不是

例 4.10. locals 介绍

>>> def foo(arg):  
...     x = 1
...     print locals()
...     
>>> foo(7)        
{'arg': 7, 'x': 1}
>>> foo('bar')    
{'arg': 'bar', 'x': 1}
------
globals 介绍
#!/bin/bash

if __name__ == "__main__":
    for k, v in globals().items(): 
        print k, "=", v
-----        
✗ python 1.py
__builtins__ = <module '__builtin__' (built-in)>
__name__ = __main__
__file__ = 1.py
__doc__ = None
__package__ = None

参考 [locals 和 globals](http://www.chinesepython.org/pythonfoundry/limodoupydoc/dive/html/dialect_locals.html)

<<<<<<< HEAD
+ functools 模块
functools 模块中有三个主要的函数 partial(), update_wrapper() 和 wraps()。
[参考](http://blog.jkey.lu/2013/03/15/python-decorator-and-functools-module/)

``` python
wraps(wrapped[, assigned][, updated])
wraps() 函数把用 partial() 把 update_wrapper() 给封装了一下。
貌似是方便加注释的

def wraps(wrapped,
          assigned = WRAPPER_ASSIGNMENTS,
          updated = WRAPPER_UPDATES):

    return partial(update_wrapper, wrapped=wrapped,
                   assigned=assigned, updated=updated)

好，接下来看一下是如何使用的，这才恍然大悟，一直在很多开源项目的代码中看到如下使用。

from functools import wraps
def my_decorator(f):
     @wraps(f)
     def wrapper(*args, **kwds):
         print 'Calling decorated function'
         return f(*args, **kwds)
     return wrapper

@my_decorator
def example():
    """这里是文档注释"""
    print 'Called example function'

example()

# 下面是输出
"""
Calling decorated function
Called example function
"""
print example.__name__ # 'example'
print example.__doc__ # '这里是文档注释'
````
=======

+ python  dict() 函数
可以很方便的 把list 转换为字典
比如：
```
list = [(key,value),(key1,value1)]
dict = dict(list)
> dict
{key:value,key1:value1}

+ 交互的输入密码
import getpass
getpass.getpass()

<<<<<<< HEAD

+ dir()  
 获取模块中的  获得模块的属性列表
  flask 中用它，获取配置信息
=======
+ python 没有switch的解决办法
http://www.pydanny.com/why-doesnt-python-have-switch-case.html

+ del 命令的使用

有时候，我们import 一个模块的组件，并不想再后面继续引用可以如下；

``` python
import thread 

_start_new_thread = thread.start_new_thread
_allocate_lock = thread.allocate_lock
_get_ident = thread.get_ident
ThreadError = thread.error
del thread
```

+ StringIO 和 BytesIO
 在内存中操作字符串的读写

 + import json

参数 indent=4，使输出更加优雅

data1 = {'b':789,'c':456,'a':123}
d1 = json.dumps(data1,sort_keys=True,indent=4)
print d1

输出：

{ 
    "a": 123, 
    "b": 789, 
    "c": 456 
}