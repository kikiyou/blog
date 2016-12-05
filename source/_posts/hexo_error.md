---
title: hexo 报错解决
tags: 
- hexo
---

# Hexo博客Bug：```{{ }}```符号引起的生成报错
<!-- more -->
今天使用hexo g 生成博客页面的时候报错了

``` bash
$ hexo g
INFO  Start processing
FATAL Something“s wrong.
Template render error: (unknown path) [Line 1, Column 155]
  unexpected token: }}
at Object.exports.prettifyError (/home/dawx/sync/blog/node_modules/hexo/node_modules/nunjucks/src/lib.js:34:15)
    at Obj.extend.render (/home/dawx/sync/blog/node_modules/hexo/node_modules/nunjucks/src/environment.js:468:27)

```

作为一个非前端人员，看到一堆js 就懵逼了

Google 之

原来是 我写博客 引用的jinja 代码中 { { } } 符号
和hexo有冲突

解决办法:

把代码 使用 ``` 注释起来就好了

推荐： 以后引用的代码最好注释起来


运行 $ hexo server 命令有时会返回这样的错误：

1
Error: watch ENOSPC ...
可以用过运行 $ npm dedupe 来解决，如果不起作用的话，可以尝试在 Linux 终端中运行下列命令：

1
$ echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
这将会提高你能监视的文件数量。