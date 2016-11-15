---
title: fabric好的写法
tags: python
---

# fabric好的写法
<!-- more -->
+ 过滤fabfile中 私有函数 和 不可调用的函数
``` python
bad:
cmds = dict([n for n in filter(lambda n: (n[0][0] != '_') and callable(n[1]), locals().items())])

new:
COMMANDS = {}
def load(filename, **kvargs):
    "Load up the given fabfile."
    execfile(filename)
    for name, obj in locals().items():
        if not name.startswith('_') and isinstance(obj, types.FunctionType):
            COMMANDS[name] = obj
```