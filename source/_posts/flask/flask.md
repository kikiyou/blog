---
title: flask源码学习
tags: 
- python
- flask
---
# flask源码学习
<!-- more -->
+ from __future__ import with_statement
  在老版本的python 中使用with

+  from threading import local
    为了解决各个线程中的变量传递问题，把变量存在一个全局字典中

        原来的写法是：

    v={key:value};在不同的线程里通过v[thread_name]来调用相应的变量；

    改进后的写法：

    tl=threading.local();

    tl是一个对象，对象的属性tl.v可以理解为一个字典：

    比如：在线程A中为tl.v赋值为nameA 相当于tl.v[thread_name]=nameA

    这样就实现了在不同的线程环境中有不同的值。
    ----------
    具体可以参考： [ThreadLocal](http://www.liaoxuefeng.com/wiki/001374738125095c955c1e6d8bb493182103fac9270762a000/001386832845200f6513494f0c64bd882f25818a0281e80000)

+ flask first module

```
flask.py

from jinja2 import Environment, PackageLoader
from werkzeug import Request, Response, LocalStack, LocalProxy
from werkzeug.routing import Map, Rule
from werkzeug.exceptions import HTTPException, InternalServerError
from werkzeug.contrib.securecookie import SecureCookie
```

+ 大型项目组织
```
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()


默认 单个应用程序的写法
/yourapplication
    /yourapplication
        /__init__.py
        /static
            /style.css
        /templates
            layout.html
            index.html
            login.html
            ...

大型应用的写法
/yourapplication
    /runserver.py
    /yourapplication
        /__init__.py
        /views.py
        /static
            /style.css
        /templates
            layout.html
            index.html
            login.html
            ...

把yourapplication.py 创建同名目录，把yourapplication.py 改为同名目录下面的__init__.py
（0）runserver.py   （以后运行项目,python runserver.py）
from yourapplication import app
app.run(debug=True)

(1) __init__.py
from flask import Flask
app = Flask(__name__)

import yourapplication.views

（2） views.py 
from yourapplication import app

@app.route('/')
def index():
    return 'Hello World!'

理解：__name__ 变量会自动变为导入的包名,这样就能导入对应 应用下的模板与静态文件
```
[参考](http://docs.jinkan.org/docs/flask/patterns/packages.html)

+ python中__name__的使用 

    1. 如果模块是被导入，__name__的值为模块名字
    2. 如果模块是被直接执行，__name__的值为’__main__’

+ route函数
def route(self, rule, **options):
    def decorator(f):
        self.add_url_rule(rule, f.__name__, **options)
        self.view_functions[f.__name__] = f
        return f
    return decorator    

给一个url规则动态注册视图函数的 decorator
@app.route("/")
def hello():
    return "Hello World!"

```
如果一个url规则是 / 结尾，用户请求是会自动定向到有/结尾的页面
如果一个url规则没有/ 结尾,用户请求的是用/结尾的页面，会报404错误

+ 路由写法的真正意义
> 路由中 rule 是浏览器请求的路径  [Rule('/<short_id>'）,endpoint='short_link_details']
> endpoint 是 处理这个请求 对应的函数 ()

        Basically this example::

            @app.route('/')
            def index():
                pass

        Is equivalent to the following::

            def index():
                pass
            app.add_url_rule('/', 'index') ##add_url_rule(rule,endpoint) 
            app.view_functions['index'] = index ##把index 和 index() 进行邦定

+ flask 中的map 
   flask 中的map 是引用 werkzeug中的Map() 
   werkzeug中的Map() 请参看werkzeug源码

+ 字典方法设置默认值

dict.setdefault('use_reloader', self.debug)

当key不存在时，设置value

+ python __call__
Python中有一个有趣的语法，只要定义类型的时候，实现__call__函数，这个类型就成为可调用的。
换句话说，我们可以把这个类型的对象当作函数来使用，相当于 重载了括号运算符。
相当于 object()= object.__call__()
class g_dpm(object):
    def __init__(self, g):
        self.g = g
    def __call__(self, t):
        return (self.g*t**2)/2

计算地球场景的时候，我们就可以令e_dpm = g_dpm(9.8)，s = e_dpm(t)。

__call__ 在那些类的实例经常改变状态的时候会非常有效。调用这个实例是一种改变这个对象状态的直接和优雅的做法。
用一个实例来表达最好不过了:

class Entity:
'''调用实体来改变实体的位置。'''

def __init__(self, size, x, y):
    self.x, self.y = x, y
    self.size = size

def __call__(self, x, y):
    '''改变实体的位置'''
    self.x, self.y = x, y

    整理一下相关server类的继承关系，如下：

+ flask服务的继承关系
BaseWSGIServer–>HTTPServer–>SocketServer.TCPServer–>BaseServer

从上面的类继承关系，我们可以很容易的理解，因为Flask是一个Web框架，所以需要一个HTTP服务，
而HTTP服务是基于TCP服务的，而TCP服务最终会有一个基础服务来处理socket。

+ 装饰器 提前把url路由给邦定了

+ functools.partial 偏函数
偏函数，用在局部的程序中，用来冻结一个函数+部分参数，作为一个新的函数
这样当输入时，直接输入原函数的另一些参数，可以省略输入
比如int 转换二进制需要两个参数
int(base=2,'10010')
18
使用便函数后可以如下
>>> from functools import partial
>>> basetwo = partial(int, base=2)
>>> basetwo.__doc__ = 'Convert base 2 string to an int.'
>>> basetwo('10010')
18

+ Flask返回json两种方式

[参考](http://blog.trytofix.com/article/detail/54/)

（1） from flask import jsonify
（2） json.dumps() + Response 


flask学习参考：

[Flask源码剖析](http://mingxinglai.com/cn/2016/08/flask-source-code/?utm_source=pyhub.cc&utm_medium=referral)
[Flask 源码剖析——服务启动篇](https://segmentfault.com/a/1190000005788124)
[菜鸟阅读 Flask 源码系列（1）：Flask的router初探](http://manjusaka.itscoder.com/2016/08/09/reading-the-fucking-flask-source-code-Part1/)
[【Flask源码解读】session 的实现与扩展](https://liuliqiang.info/post/flask-session-explore/)
[Flask 源码简单学习](http://z3lion.com/post/flaskyuan-ma-xue-xi)
[The Way To Flask](https://luke0922.gitbooks.io/the-way-to-flask/content/)

[Flask logging 使用](https://liuliqiang.info/post/79/)
[Flask-Login 使用和进阶](https://liuliqiang.info/post/103/)
[Flask-Admin](https://liuliqiang.info/post/115/)
[Flask config 在 flaskeleton 上的实践](https://liuliqiang.info/post/97/)
[Flask 0.10.1](http://www.pythondoc.com/flask/index.html)


[Python修饰器的函数式编程](http://coolshell.cn/articles/11265.html)

这本《explore flask》可能会帮助你理清思路。
附《explore flask》中文翻译：https://spacewander.github.io/explore-flask-zh