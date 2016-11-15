---
title: post_vs_get
date: 2016-07-14 10:19:44
tags: http
---
## POST  和 GET 的区别
<!-- more -->
1. get 的形式如下：
    http://xxx.com?key1=value1&key2=value2

    get  适合无副作用  幂等的url

        传输是显式的传输，附加在url上
    劣势： 传输的数据量   受URL长度限制

2. POST 的形式如下：
    http://xxx.com
    request body = {key1:value1,key2:value2}

    post 适合 非幂等 有副作用
    优势：POST 传输是附加在 request body中的不受,url 长度限制

参考：(https://www.zhihu.com/question/27622127)

[get: RFC 2616 - Hypertext Transfer Protocol -- HTTP/1.1](https://link.zhihu.com/?target=http%3A//tools.ietf.org/html/rfc2616%23section-9.3)

[post: RFC 2616 - Hypertext Transfer Protocol -- HTTP/1.1]()


