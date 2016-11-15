---
title: flask中jinja模版和Vue兼容
tags: 
- flask
- vue
---
# flask中jinja模版和Vue兼容
<!-- more -->
``` bash
jinja 和 Vue 都是用{{ }} 
```
笨办法：

方法1

使用jinja的raw, 使用raw之后，里面的就不会被jinja意外解析了

{%raw%}
<h1 class="title">{{name}}</h1>
{%endraw%}

聪明办法：
主要思路是通过修改Jinja2的配置，让他只渲染之间的数据，注意空格，而Vue.js处理不加空格的模板。

操作：
``` bash
app.jinja_env.variable_start_string = '{{ '
app.jinja_env.variable_end_string = ' }}'
```
就酱~这样如果使用了ide，语法高亮什么的也支持了。
``` bash
jinja2: {{ site.brand }}
vue.js: {{site.brand}}
```
我这个项目中还使用了flask-bootstrap作为模板，不幸的是，flask-bootstrap使用的大括号都没加空格，导致页面渲染时出现问题。
所以我将flask-bootstrap源码进行了修改，安装时，只要用我的数据源安装即可git+https://github.com/Panmax/flask-bootstrap.git