---
title: JavaScript
tags: 
- JavaScript
---

# JavaScript 基础学习
<!-- more -->
# jQuery架构设计与实现 (买来看一下)

+ 给元素添加新内容

    - append() - 在被选元素的结尾插入内容

    - prepend() - 在被选元素的开头插入内容

    - after() - 在被选元素之后插入内容

    - before() - 在被选元素之前插入内容
    

+ JavaScript 中创建对象 不需要实例化

+ JavaScript 中 .  和 [ ] 都可以表示对象的属性

''' JavaScript

var work = {}    //定义了一个对象
var education = {}


work.employer = "1111"
work.city = "Xian"
work.years = "100"
education['school'] = "MIT"

$("#main").prepend(work['city']);
$("#main").prepend(education.school);
’‘’

+ 说到AJAX就会不可避免的面临两个问题，第一个是AJAX以何种格式来交换数据？第二个是跨域的需求如何解决？

但到目前为止最被推崇或者说首选的方案还是用JSON来传数据，靠JSONP来跨域。

+ jQuery 处理DOM 

 - $('tag')

 - $('.class')   // .操作 class

  - $('#id')    // #操作id

  + jQuery 中查找元素

    - $('#ljq').parent()     1      上查一个
    - $('#ljq').parents()     many   上查多个
    - $('#ljq').children()     1   下查一个
    - $('#ljq').find()     many   下查多个
    - $('#ljq').siblings()  兄弟姐妹

+ .toggleClass()  切换对应的 class

$(selector).toggleClass(class,switch)

+ .attr(attributeName,value)
  改变DOM 对象的属性值  比如：<a href="http://www.w3school.com.cn" id="w3s">W3School.com.cn</a>
  对象a 有属性 href 对应的值是 http://www.w3school.com.cn  
  可以通过attr方法 改变

+ .css()

    .css( propertyName, value )
    描述:设置一个或多个CSS属性匹配的元素集合

+ 获取/设置 html 和 text

    $('.article-item').text();
    $('.article-item').html();

+ .remove( [selector ] )
在DOM中删除匹配的元素集合。

+ .insertBefore() 和 .insertAfter()

  在之后添加元素 和之前插入元素

  相当于如下代码：
    firstArticleItem = $('.article-item').first();
    firstArticleItem.append('<img src="http://placepuppy.it/200/300">');
    firstArticleItem.prepend('<img src="http://placepuppy.it/200/300">');

+ .each

相当于 python中的 map()
function numberAdder() {
    var text, number;
    text = $(this).text();
    number = text.length;
    $(this).text(text + " " + number);
}

$('p').each(numberAdder)

+ jQuery function

Pass your function into the jQuery object, like so:

function someFunction() {
    // Do interesting things
}
$(someFunction)
or

$(function(){
    // Do interesting things
})

+ monitorEvents 监控事件

var inputFields = jQuery('input');
undefined
var firstInput = inputFields[0];
undefined
monitorEvents(firstInput)

+ 事件 类型
 
 [事例](https://developer.mozilla.org/en-US/docs/Web/Events)
 1. Form events
    resetdu
    submit

 2. Focus events
    change
    blur

 3. Input devices events
 keyup
 click
 mousemove


 4. view events
 scroll

 + 事件侦听

 $('#my-button').on('click',function(){
     $('button').remove();
 })

 [jquery事件处理](http://api.jquery.com/category/events/)

+ ajax .getJson 从指定url获取 json数据

+ jquery 中根据表单name获取值
var payment = $("input[name='payment']:checked").val();

+ 原生Ajax 

xmlhttp=new XMLHttpRequest();   // 1. 创建对象

xmlhttp.onreadystatechange=function() //3. 如果状态改变，就获取返回结果
  {
  if (xmlhttp.readyState==4 && xmlhttp.status==200)
    {
    document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
    }
  }
  
xmlhttp.open("GET", "ajaxtest.php?username=" + str, true); //2. 编制请求
xmlhttp.send(); //3. 发送

+ 闭包

闭包的概念在javascript中用的比较多 
闭包： 闭包说白了就是函数的嵌套，内层的函数可以使用外层函数的所有变量，即使外层函数已经执行完毕。
      外层函数的变量 回保存起来 和 内层函数同时存在