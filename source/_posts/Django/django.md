好书 ：
Martin Fowler重构:改善既有代码的设计

Django中文文档：
https://www.gitbook.com/book/wizardforcel/django-chinese-docs-18/details

# django学习

$ django-admin.py  startproject superlists
$ python manage.py  runserver

##创建git仓库
cd superlists/
git init .
echo "db.sqlite3" >>  .gitignore
git add .
git status

git rm -r --cached superlists/__pycache__
echo "__pycache__" >> .gitignore
echo "*.pyc" >> .gitignore

git diff --staged
显示将要提交的内容的内容差异

+ git 别名
git config --global alias.st status
以后 git st 效果等同于  git status

## 创建一个应用
python manage.py startapp lists

+ 单元测试要测试的其实是 逻辑 流程控制 配置。


## 注册应用
vi superlists/settings.py 

## 创建数据库迁移
python manage.py  makemigrations

## 创建真正的数据库
python manage.py migrate

## 清楚数据库
rm db.sqlite3
python manage.py migrate --noinput


## django内部测试模块  liveServerTestCase
mkdir function_tests
touch function_tests/__init__.py
git mv function_tests.py function_tests/tests.py

python manage.py test function_tests

self.live_server_url   --> 使用变量不使用硬编码


+ 运行功能测试
python manage.py test function_tests

+ 运行单元测试
python manage.py test lists

+ 调用Django内部测试客户端
response = self.client.get('/lists/the-only-list-in-the-world/') 

self.client.get 的作用和selenium中get的作用是一致的

self.assertContains(response,'itemey 1')

self.assertContains是djangp的内部测试方法，能比较友好的处理响应的编码与解码

+ 捕获URL中的参数

如下：
`    url(r'^lists/(.+)/$', 'lists.views.view_list',name='view_list'),`
其中,(.+) 是表示捕获组，如果访问的是/lists/1/, view_list的视图除了常规的 request参数之外，还会获得第二个参数，即字符串 "1"。
如果访问/lists/foo/,视图就是 view_list(request,"foo")。

+ Django orm 的反向查询

{% for item in list.item_set.all%}

.item_set 叫作“反向查询”(reverse lookup),是 Django提供的非常有用的ORM功能，可以在其他表中查询某个对象的相关记录。

+ bootstrap官网,可以逛一逛
http://getbootstrap.com/

+ 搜集静态文件
vi settings.py
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.8/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = os.path.abspath(os.path.join(BASE_DIR,'../static'))

python manage.py collectstatic

+ django 可以载入假数据进行开发
# Init data or generate fake data source for development
FIXTURE_DIRS = [os.path.join(BASE_DIR, 'fixtures'), ]

fake.json
init.json


## Django 简单模板学习
``` bash 
from django.http import HttpResponse

# Create your views here.
def home(request):
    html_var = 'xxx'
    html_ = f"""<!DOCTYPE html>
    <html lang=en>
    <head>
    </head>
    <body>
    <h1>Hello World!</h1>
    <p> This is {html_var} coming through</p>
    </body>
    </html>
    """
    return HttpResponse(html_)

``` 

Django 模板调试参数verbatim

如下使用,可以显示变量的名字
``` <p> This is{% verbatim %} {{ html_var }} {% endverbatim %}coming through</p> ```

+ 使用Q 对象进行复杂的查询
例如，下面的Q 对象封装一个LIKE 查询：

from django.db.models import Q
Q(question__startswith='What')
