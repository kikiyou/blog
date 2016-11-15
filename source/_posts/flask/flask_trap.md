---
title: flask源码学习
date: 2016-09-25 14:01
tags: 
- python
- flask
---
# 那些年我用flask踩过的坑
<!-- more -->
+ config对象中的  属性必须大写，才能被继承使用
    这一点，官方文档中有说，但是真的是只有一句话

    > Only values in uppercase are actually stored in the config object later on.

    > 只有大写名称的值才会被存储到配置对象中。

    我觉得这么反人类的设定，怎么也要说三便的！


如下是 flask v0.3 源码中的内容：
``` python
class Config(dict):
    def from_object(self, obj):
    # 从对象中导入配置
        if isinstance(obj, basestring):
        obj = import_string(obj)
        for key in dir(obj):   ##使用内置dir函数 获取class中的 属相
            if key.isupper():  ##----只提取大写的 属性 （坑爹要求）---
                self[key] = getattr(obj, key)  ##把别人的属性 的k/v 变成自己的
```