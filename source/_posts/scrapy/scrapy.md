# scrapy 的使用

1. items.py  内容储存方式
2. pipelines.py  流程
3. setting.py 设定



## 安装
pip install scrapy

## 创建一个项目
scrapy startproject tutorial

➜  tree
.
├── scrapy.cfg
└── tutorial
    ├── __init__.py
    ├── items.py
    ├── pipelines.py
    ├── settings.py
    └── spiders
        └── __init__.py

2 directories, 6 files


## 运行一个项目

cd tutorial/
vim tutorial/spiders/quotes_spider.py

1. 列出 可用 spider
scrapy list 

2.  运行
scrapy crawl quotes



## Selectors选择器简介

XPath表达式的例子及对应的含义:

/html/head/title: 选择HTML文档中 <head> 标签内的 <title> 元素
/html/head/title/text(): 选择上面提到的 <title> 元素的文字
//td: 选择所有的 <td> 元素
//div[@class="mine"]: 选择所有具有 class="mine" 属性的 div 元素

>>> response.xpath('//base/@href').extract()
[u'http://example.com/']

>>> response.css('base::attr(href)').extract()
[u'http://example.com/']

@符号代表 属性

映射:
response.selector.xpath()  --》 response.xpath()
response.selector.css()  --》 response.css() 



## demo 

1.  shell  调试
scrapy shell "http://quotes.toscrape.com/page/1/"

自动 会把页面返回放到 response 类中
2.  response.body



## 支持 js   scrapy-splash
+ 安装
    pip install scrapy-splash

[Scrapy爬虫中使用Splash处理页面JS](http://ae.yyuap.com/pages/viewpage.action?pageId=919763)
