---
title: sqlalchemy_session
date: 2016-07-14 17:34:47
tags:
---
#sqlalchemy session管理
<!-- more -->
## session基础用法
``` python
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

# an Engine, which the Session will use for connection
# resources
some_engine = create_engine('mysql://root:1234@localhost/test')

# create a configured "Session" class
Session = sessionmaker(bind=some_engine)

# create a Session
session = Session()

# work with sess
result = session.execute('show variables')
for row in result:
    print row
```
### sessionmaker 应该放在哪里？
+ 如果程序启动的时候知道连接到哪个数据库，就把sessionmaker 放在 `__init__.py`中，在别的模块中 from mypackage import Session 这样引用
+ 如果程序启动的时候不知道要去连接哪个数据库，可以使用 sessionmaker.configure()


## 推荐的session 用法
``` python
from contextlib import contextmanager
class ThingOne(object):
    def go(self, session):
        session.query(FooBar).update({"x": 5})

class ThingTwo(object):
    def go(self, session):
        session.query(Widget).update({"q": 18})
@contextmanager
def session_scope():
    """Provide a transactional scope around a series of operations."""
    session = Session()
    try:
        yield session
        session.commit()
    except:
        session.rollback()
        raise
    finally:
        session.close()


def run_my_program():
    with session_scope() as session:
        ThingOne().go(session)
        ThingTwo().go(session)
```

## Thread-Local模式 —— 生命周期与 request 同步
``` python
Web Server          Web Framework        SQLAlchemy ORM Code
--------------      --------------       ------------------------------
startup        ->   Web framework        # Session registry is established
                    initializes          Session = scoped_session(sessionmaker())

incoming
web request    ->   web request     ->   # The registry is *optionally*
                    starts               # called upon explicitly to create
                                         # a Session local to the thread and/or request
                                         Session()

                                         # the Session registry can otherwise
                                         # be used at any time, creating the
                                         # request-local Session() if not present,
                                         # or returning the existing one
                                         Session.query(MyClass) # ...

                                         Session.add(some_object) # ...

                                         # if data was modified, commit the
                                         # transaction
                                         Session.commit()

                    web request ends  -> # the registry is instructed to
                                         # remove the Session
                                         Session.remove()

                    sends output      <-
outgoing web    <-
response
```
``` python
@app.before_request
def init_session():
    g.session = Session()

@app.tear_down_request
def close_session():
    g.session.close()
```
这其实才是最适合 web 项目的 session 管理方式。（伪代码中没有写 commit 和 rollback，可自行添加）这样即避免了连接池的过快消耗，又避免了并发问题。
这也是 SQLAlchemy 文档中推荐的做法。
绑定request 请求前申请session  request之后释放session

实践上更靠谱的一段代码可能是：
``` python
from my_web_framework import get_current_request, on_request_end
from sqlalchemy.orm import scoped_session, sessionmaker

Session = scoped_session(sessionmaker(bind=some_engine), scopefunc=get_current_request)

@on_request_end
def remove_session(req):
    Session.remove()
```
Flask-SqlAlchemy就是用上面的方法实现的



## sqlalchemy session 总结
+ **sqlalchemy会把一个表对象 附加给一个session ,如果这个session不close，别的session无法使用这个对象**

会报错：
User 对象已经附加给session 6 ,当前是 session 7 ,无法操作User
``` python
InvalidRequestError: Object '<User at 0x7f1e8fede090>' is already attached to session '6' (this is '7')
```
+ session的close() 只是释放对表的控制权,并不是断开连接(connect)，所以close() 之后依然可以执行查询

+ 使用scoped_session() 之后获得的session，如果不执行session.remove(),所获得的session都是同一个session

+ session.remove() 并不会，执行close()，所以正常的顺序应该是
    1. session = scoped_session(session_factory)
    2. s1 = session()
    3. s1.add(jessica)
    4. s1.commit()
    5. s1.close()
    5. session.remove()
+ 因为如果没有执行 session.remove() 不需要执行 s1.close()，
  应为同一个 session不需要释放，就可以提交。

如下 示例验证了上面的说法
``` python
from sqlalchemy import Column, String, Integer, ForeignKey
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    name = Column(String)


from sqlalchemy import create_engine
engine = create_engine('sqlite:///test.db')

from sqlalchemy.orm import sessionmaker
session = sessionmaker()
session.configure(bind=engine)
Base.metadata.create_all(engine)

# Construct the first session object
s1 = session()
# Construct the second session object
s2 = session()
>>> s1 is s2
False
>>> jessica = User(name='Jessica')
>>> s1.add(jessica)
>>> s2.add(jessica)
Traceback (most recent call last):
......
sqlalchemy.exc.InvalidRequestError: Object 'User at' is already attached to session '1' (this is '2')

##################
>>> session_factory = sessionmaker(bind=engine)
>>> session = scoped_session(session_factory)
>>> s1 = session()
>>> s2 = session()
>>> jessica = User(name='Jessica')
>>> s1.add(jessica)
>>> s2.add(jessica)
>>> s1 is s2
True
>>> s1.commit()
>>> s2.query(User).filter(User.name == 'Jessica').one()
```
参考：
http://my.oschina.net/lionets/blog/407263

http://docs.sqlalchemy.org/en/latest/orm/session_basics.html


+ 普通session 和 使用 scoped_session的区别 [传送门](http://pythoncentral.io/understanding-python-sqlalchemy-session/)
