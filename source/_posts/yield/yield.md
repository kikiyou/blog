# yield 生成器


+ 列表推导式和元组推导式的区别

In [1]:lt = [1, 2, 3, 4]
In [2]:gen = [i for i in lt]
In [3]: gen
Out[3]:Out[3]: [1, 2, 3, 4]

In [4]:gen = (i for i in lt)
In [5]:gen
Out[5]: <generator object <genexpr> at 0x7fd271c488c0>

[参考](http://www.dabeaz.com/generators/Generators.pdf)


+ iter(obj) 转换成可迭代对象
In [6]: lt = [1, 2, 3, 4]

In [7]: iter(lt)
Out[7]: <listiterator at 0x7fd271c421d0>


for 其实式迭代的语法糖，for循环本质如下：
```
it = iter(lst)
while True:
try:
        val = it.next()
        print val
except StopIteration:
    pass
```

## 支持迭代

+ 自定义对象可以支持迭代

+ 示例： 
for x in conuntdown(10):
    print x
>> 10 9 8 7 6 5 4 3 2 1

+ 需要实现上面的功能，需要你的对象 支持 __iter__() and netx() 方法

+ 示例：
```
class countdown(object):
    def __init__(self,start):
        self.count = start
    def __iter__(self):
        return self
    def next(self):
        if self.count <= 0:
            raise StopIteration
        r = self.count
        self.count -= 1
        retun r

c = countdown(5)
for i in c:
    print i
> 5 4 3 2 1

def countdown(n):
 while n > 0:
 yield n
 n -= 1
>>> for i in countdown(5):
        print i
> 5 4 3 2 1

