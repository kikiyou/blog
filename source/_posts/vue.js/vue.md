# vue 学习

## npm 和 bower的区别

npm 管理前端的依赖
bower 管理后端的依赖

网站：jsfiddle.net


+ vue 中# 表示id的引用

1. 开始
2. 响应式DOM
3. 明白VueJS实例
4. Vue Cli
5. 组件
6. Forms
7. Directives,Filters & Minxs
8. Animation & Transitions
9. Working with Http
10. Routing
11. State Management
12. deploying a Vuejs


+ 感觉el里面 很像 类的属性和方法


+ 绑定属性
<a v-bind:href="link">Google</a>  

+ 重载
this.title = "Hello"
可以重新，定义，改变data中title属性的值

+ 使用v-once关闭重载
<h1 v-once>{{ title }}</h1>


+ 输出html
<p>{{ finishedLink }}</p>

上面的这种是错误的，应该使用下面这种

+ 获取侦听的事件
html：
<p v-on:mousemove="updateCorrdinates">Coordinates: {{ x }} / {{ y }}</p>


updateCorrdinates: function(evnet){
this.x = event.clientX;
this.y = event.clientY;
}

如上就可以获取，鼠标x轴和y轴的数据

+ 给函数输入参数
<button v-on:click="increase(2, $event)">Click me</button>
<p>{{ counter }}</p>
methods:{
    updateCorrdinates: function(evnet){
    this.x = event.clientX;
    this.y = event.clientY;
    }
}

+ 停止even监控
<span v-on:mousemove.stop="">DEAD SPOT </span>

+ 侦听键盘
<input type="text" v-on:keyup.enter.space="alertMe">

methods:{
    alertMe: function(){
      	alert('Alert!');
    }
}

+ 第二个绑定数据的办法
在data中定义属性，name： "monkey"

<input type="text" v-model="name">


+ 重置属性
data 中result：''
<input type="text" v-model="result">
methods:{
      this.result = this.counter > 5 ? 'Greater 5' : 'Smaller 5';
}


+ 自动跟踪属性变化
<input type="text" v-model="result()">
methods:{
    result(){
    	return this.counter > 5 ? 'Greater 5' : 'Smaller 5';
    }
}

注： function关键字 被省略了

+ 计算属性
<p>{{ output }}</p>

  computed:{
  	output: function(){
    	    return this.counter > 5 ? 'Greater 5' : 'Smaller 5';

    }
  },

计算属性可以实现方法同样的功能(注: 计算属性是有缓存的方法)

看到了第22个视频

vue 前端框架：iview
https://github.com/iview/iview

+ watch 组件

  watch:{
  counter: function(value){
      var vm = this;
      setTimeout(function(){
      vm.counter = 0;
      },2000);
  	}
  },

+ 循环
<div v-for="(value, key, index) in person">{{ key }}: {{ value }} {{i}} </div>
+ vuejs中的简写

v-on：click  ---> @click
v-bind:href="www.baidu.com  ---> ：href="www.baidu.com
