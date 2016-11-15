---
title: multiprocessing pool 使用中的作用域
date: 2016-10-30 10:30:44
tags: 
- ansible
- python
---

# multiprocessing pool 使用中的作用域
<!-- more -->
在看ansible源码的过程中发现 ansible作者遇到多进程并发 作用域的问题

先把他遇到的问题与解决办法归纳于此：
[Multiprocessing: How to use Pool.map on a function defined in a class?](http://stackoverflow.com/questions/3288595/multiprocessing-how-to-use-pool-map-on-a-function-defined-in-a-class)

``` python
from multiprocessing import Pool

p = Pool(5)
def f(x):
     return x*x

p.map(f, [1,2,3])

it works fine. However, putting this as a function of a class:

class calculate(object):
    def run(self):
        def f(x):
            return x*x

        p = Pool()
        return p.map(f, [1,2,3])

cl = calculate()
print cl.run()

上面的这个写发会有如下报错:

Exception in thread Thread-1:
Traceback (most recent call last):
  File "/sw/lib/python2.6/threading.py", line 532, in __bootstrap_inner
    self.run()
  File "/sw/lib/python2.6/threading.py", line 484, in run
    self.__target(*self.__args, **self.__kwargs)
  File "/sw/lib/python2.6/multiprocessing/pool.py", line 225, in _handle_tasks
    put(task)
PicklingError: Can't pickle <type 'function'>: attribute lookup __builtin__.function failed

```
## 如下为解决办法

+ 版本1

``` python
from multiprocessing import Process, Pipe
from itertools import izip

def spawn(f):
    def fun(pipe,x):
        pipe.send(f(x))
        pipe.close()
    return fun

def parmap(f,X):
    pipe=[Pipe() for x in X]
    proc=[Process(target=spawn(f),args=(c,x)) for x,(p,c) in izip(X,pipe)]
    [p.start() for p in proc]
    [p.join() for p in proc]
    return [p.recv() for (p,c) in pipe]

if __name__ == '__main__':
    print parmap(lambda x:x**x,range(1,5))
```
+ 版本2

``` python
from multiprocessing import Pool 

def f(x):
    return x**x

class calculate(object):
    def run(self):
        p = Pool()
        return p.map(f, [1,2,3，4])

cl = calculate()
print cl.run()

```

+ 版本3

``` python
from multiprocessing import Pool 

def _executor_hook(x):
    (calculate, arg) = x
    return calculate.f(arg)

class Calculate(object):
    def f(self,x):
        return x**x
    def run(self):
        p = Pool()
        args = [ (self,x) for x in [1,2,3,4] ]
        return p.map(_executor_hook,args)

cl = Calculate()
print cl.run()
```

+ 版本4

这一版本，主要是解决，并发运行过程中不能使用Ctrl-C 终止的问题
``` python
import multiprocessing
import signal
import Queue

from time import sleep

def _executor_hook(job_queue, result_queue):
    ''' callback used by multiprocessing pool '''
    signal.signal(signal.SIGINT, signal.SIG_IGN)
    while not job_queue.empty():
        try:
            job = job_queue.get(block=False)
            Calculate, arg = job
            result_queue.put(Calculate.f(arg))
        except Exception:
            print Exception

class Calculate(object):
    def f(self,x):
        sleep(1)
        return x**x

    def run(self):
        ''' xfer & run module on all matched hosts '''
        
        alist = [ (self,x) for x in [1,2,3,4] ]

        job_queue = multiprocessing.Queue()
        result_queue = multiprocessing.Queue()

        for i in alist:
            job_queue.put(i)

        workers = []
        for i in alist:
            tmp = multiprocessing.Process(target=_executor_hook,
                                    args=(job_queue, result_queue))
            tmp.start()
            workers.append(tmp)

        try:
            for worker in workers:
                worker.join()
        except KeyboardInterrupt:
            print 'parent received ctrl-c'
            for worker in workers:
                worker.terminate()
                worker.join()
        
        results = []
        while not result_queue.empty():
            results.append(result_queue.get(block=False))
        
        return results
         
 
cl = Calculate()
print cl.run()
```