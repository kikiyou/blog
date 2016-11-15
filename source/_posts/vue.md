---
title: vue 学习
---
# vue 学习
<!-- more -->
+ 
[Vue.js——基于$.ajax实现数据的跨域增删查改](http://www.cnblogs.com/keepfool/p/5648674.html)

+ 每个Vue实例都会代理其data对象里的所有属性

var data = { a: 1 }
var vm = new Vue({
  data: data
})

vm.a === data.a // -> true

+ 