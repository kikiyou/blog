---
title: flask的配置管理
date: 2016-09-25 14:01
tags: 
- python
- flask
---
# flask的配置管理
<!-- more -->
+ flask的配置管理

    flask的配置管理方式，支持使用应用工厂模式来使用应用，

    但是 坑爹的是必须大写的变量才能被导入

    这一功能是 v0.3中引入的，所以 我决定看下v0.3 中相应的源码

``` python 
class Flask(_PackageBoundObject):
    #: default configuration parameters
    default_config = ImmutableDict({
        'DEBUG':                                False,
        'SECRET_KEY':                           None,
        'SESSION_COOKIE_NAME':                  'session',
        'PERMANENT_SESSION_LIFETIME':           timedelta(days=31),
        'USE_X_SENDFILE':                       False
    })

    def __init__(self, import_name):
        self.config = Config(self.root_path, self.default_config)



class Config(dict):
"""
工作看起来像字典，提供从文件，特殊字典，和对象中导入等方法，填充到在配置中。
"""
    def __init__(self, root_path, defaults=None):    ##flask 对象会初始化导入 默认的配置
        dict.__init__(self, defaults or {})
        self.root_path = root_path

    flask 中的 config 类 有三个方法：
    def from_envvar(self, variable_name, silent=False):
    # 从环境变量中导入配置
    # 从环境后读路径，调用from_pyfile

    def from_pyfile(self, filename):
    # 从文件中导入配置
    #execfile() 后调用 from_object

    def from_object(self, obj):
    # 从对象中导入配置
        if isinstance(obj, basestring):
        obj = import_string(obj)
        for key in dir(obj):   ##使用内置dir函数 获取class中的 属相
            if key.isupper():  ##只读大写的 属性 （坑爹要求）
                self[key] = getattr(obj, key)  ##把别人的属性 的k/v 变成自己的




# debug = ConfigAttribute('DEBUG') 
# 把类中书属性 返回

class ConfigAttribute(object):
    """Makes an attribute forward to the config"""

    def __init__(self, name):
        self.__name__ = name

    def __get__(self, obj, type=None):
        if obj is None:
            return self
        return obj.config[self.__name__]

    def __set__(self, obj, value):
        obj.config[self.__name__] = value
```

+ flask config 的使用

``` python
from flask import current_app


config = current_app.config
SITE_DOMAIN = config.get('SITE_DOMAIN')

```