---
title: werkzeug学习
date: 2016-08-18 16:10:02
tags: 
- python
---
# werkzeug学习
<!-- more -->
+ 学习shortly.py

+ os.path.dirname(__file__)
获取运行脚本的目录，如果是绝对路径运行，会有完整路径，如果是依相对路径运行就是空

print os.path.join(os.path.dirname(__file__),'static')

python /home/dawx/WorkSpace/shortly/shortly.py
》/home/dawx/WorkSpace/shortly/static

cd /home/dawx/WorkSpace/shortly/
python shortly.py
> static

+ def wsgi_app(self,environ, start_response):
environ 变量存储了 客户端的环境信息


+ 36进制转换函数
def base36_encode(number):
    assert number >= 0, 'positive integer required'
    if number == 0:
        return '0'
    base36 = []
    while number != 0:
        number, i = divmod(number, 36)
        base36.append('0123456789abcdefghijklmnopqrstuvwxyz'[i])
        # print base36
    return ''.join(reversed(base36))


for x in xrange(1,999):
    print base36_encode(x)

+ werkzeug 的使用

使用werkzeug可以对http请求进行响应 比如 在页面打印 "hello world"

但要打印 丰富复杂的html页面 需要借助jinja2模版引擎

jinja2 就根据定义好的模版文件  渲染个正确的html文档

然后 调用 Response类 把内容返回给客户端

客户端收到服务器的数据,浏览器 呈现出来

+ werkzeug中的Map()

from werkzeug.routing import Map
self.url_map = Map()

werkzeug.routing中Map()的示例
    >>> m = Map([
    ...     # Static URLs
    ...     Rule('/', endpoint='static/index'),
    ...     Rule('/about', endpoint='static/about'),
    ...     Rule('/help', endpoint='static/help'),
    ...     # Knowledge Base
    ...     Subdomain('kb', [
    ...         Rule('/', endpoint='kb/index'),
    ...         Rule('/browse/', endpoint='kb/browse'),
    ...         Rule('/browse/<int:id>/', endpoint='kb/browse'),
    ...         Rule('/browse/<int:id>/<int:page>', endpoint='kb/browse')
    ...     ])
    ... ], default_subdomain='www')
    
    >>> c = m.bind('example.com')
    >>> c.build("kb/browse", dict(id=42))
    'http://kb.example.com/browse/42/'
    >>> c.build("kb/browse", dict())
    'http://kb.example.com/browse/'
    >>> c.build("kb/browse", dict(id=42, page=3))
    'http://kb.example.com/browse/42/3'
    >>> c.build("static/about")
    '/about'
    >>> c.build("static/index", force_external=True)
    'http://www.example.com/'

    >>> c = m.bind('example.com', subdomain='kb')
    >>> c.build("static/about")
    'http://www.example.com/about'

    [Flask 路由做范围限制](http://liyangliang.me/posts/2014/02/range-validation-in-flask-routing/)
    