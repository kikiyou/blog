---
title: 进程线程的区别(threading 源码学习)
date: 2016-10-30 10:19:44
tags: 
- python
---
# 进程线程的区别(threading 源码学习)

python 中的threading 模块是对 thread模块的封装

默认thread模块是C实现的，我对C语言并不了解，幸好官方提供了dummy_thread模块，
dummy_thread 是 对thread的python 实现，通过他可以简单理解thread
注：dummy_thread 无法实现多线程
<!-- more -->
[dummy_thread](https://hg.python.org/cpython/file/2.7/Lib/dummy_thread.py)

[这幅图大好](https://software.intel.com/sites/default/files/m/5/7/f/a/b/12568-2.1.1_e7_ba_bf_e7_a8_8b_e4_b8_8e_e8_bf_9b_e7_a8_8b_e7_9a_84_e5_8c_ba_e5_88_ab.pdf)
process： single-threaded process
threaded： Multi-Threaded

+ 为什么使用线程

    1. 并行需求
    2. 避免因i/o缓慢 引起的阻塞

+ ihooks module 的使用

``` python
import ihooks, imp, os

def import_from(filename):
    "Import module from a named file"

    loader = ihooks.BasicModuleLoader()
    path, file = os.path.split(filename)
    name, ext  = os.path.splitext(file)
    m = loader.find_module_in_dir(name, path)
    if not m:
        raise ImportError, name
    m = loader.load_module(name, m)
    return m

colorsys = import_from("/python/lib/colorsys.py")

print colorsys

<module 'colorsys' from '/python/lib/colorsys.py'>
```
ihooks 绝对路径导入

+ 线程的 启动 结束 加锁 释放

+ 把要执行的代码 放到run方法里面

+ python 线程同步机制

    - Locks, 
        锁

    - RLocks, 
        重复锁

    - Semaphores, 

        信号量semaphore 
        是一个变量，控制着对公共资源或者临界区的访问。信号量维护着一个计数器，指定可同时访问资源或者进入临界区的线程数。 
        每次有一个线程获得信号量时，计数器-1。若计数器为0，其他线程就停止访问信号量，直到另一个线程释放信号量。 
 
    - Conditions, 
        条件
        condition.acquire()	#获取条件锁
        condition.notify()  #唤醒消费者线程
        condition.release()	#释放条件锁

        with self.condition： ##可以用with 代替 acquire 和 release
            condition.wait()	#等待商品，并且释放资源

    - Events
        事件

    - Queues
        队列




+ 多进程中 def Pipe(duplex=True)


参考：
[详细讲解Python线程应用程序操作](http://developer.51cto.com/art/201002/184938.htm)
[Python 多线程](http://www.runoob.com/python/python-multithreading.html)
[Python线程指南](http://www.cnblogs.com/huxi/archive/2010/06/26/1765808.html)
[python实现线程池](http://ucode.blog.51cto.com/10837891/1766332)
[Python线程池详细讲解](http://blog.csdn.net/php_fly/article/details/18155421)

[Python 线程(threading) 进程(multiprocessing)](http://www.cnblogs.com/MrZhangLoveLearning/p/5079941.html)
[Python线程同步机制](http://yoyzhou.github.io/blog/2013/02/28/python-threads-synchronization-locks/)