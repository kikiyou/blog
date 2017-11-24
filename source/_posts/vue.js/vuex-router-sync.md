#vuex-router-sync

1. vuex-router-sync是用来干什么？
官网就一句话：
Effortlessly keep vue-router and vuex store in sync.

这里的同步是什么意思？如果所有views都共用一个store的话状态不都是同步的吗？

2. 
https://github.com/vuejs/vuex-router-sync#how-does-it-work

以下3个可以从vuex取得并使用

store.state.route.path   // current path (string)
store.state.route.params // current params (object)
store.state.route.query  // current query (object)