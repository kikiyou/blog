---
title: project 技术栈
---
#一个项目 需要的技术栈
<!-- more -->
基本选型

Flask、Gevent、Gunicorn、Mongodb、Nginx、Wrapped Memecache、ElasticSearch

运维与监控

Fabric、Bakthat、psutil、NewRelic、Sentry 
在重复劳动中，机器与我们相比，它不会犯错。

Response Handler

Gevent without block and force limited timeout.

FarBox API

Jinja2、PyJade、Mongodb、GeventWebsocket（with Nginx Proxy）

Desktop APP

FarBox Editor、PySide、QT、QML、Javascript

Some Tips
UnicodeWithAttrs

__call__

get_value_from_data

def get_value_from_data(data, attr, default=None):
    try:
        attrs = attr.split('.')[:25]
        for attr in attrs:
            if type(data) == dict:
                data = data.get(attr, None)
            else:
                data = getattr(data, attr, None)
            if data is None or isinstance(data, LazyDict):
                if default is not None:
                    return default
                else:
                    return None
    except RuntimeError:
        return None
    return data

Thinking means, not solutions!
Why Python

Why Flask & Jinja2

Why Mongodb

Why Gevent

Why Wrapped Memecache

Why PySide

Why Why?

Life means, not technology!
工程师与用户体验
工程师比多数PM更了解用户体验

却不怎么在乎自己的体验

从工具开始改变, 不是极客不是nerd，只是生活家.