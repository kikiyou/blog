---
title: fabric
date: 2016-08-14 10:19:44
tags: 
- python
---

# fabric学习
<!-- more -->
+ 基于字典的字符串格式化

>>> params = {"server":"mpilgrim", "database":"master", "uid":"sa", "pwd":"secret"}
>>> "%(pwd)s" % params                                    1
'secret'
>>> "%(pwd)s is not a good password for %(uid)s" % params 2
'secret is not a good password for sa'

使用字典格式化字符串更加简短，可读性也更好。

+ execfile()
 python 内置函数 可以用来执行一个文件

+ filter() / map()
    filter(function, sequence)：对sequence中的item依次执行function(item)，将执行结果为True的item组成一个List/String/Tuple（取决于sequence的类型）返回：
    >>> def f(x): return x % 2 != 0 and x % 3 != 0 
    >>> filter(f, range(2, 25)) 
    [5, 7, 11, 13, 17, 19, 23]
    >>> def f(x): return x != 'a' 
    >>> filter(f, "abcdef") 
    'bcdef'

>>>a=[1,2,3,4,5,6,7]
>>>b=filter(lambda x:x>5, a)
>>>print b
>>>[6,7]
如果filter参数值为None，就使用identity（）函数，list参数中所有为假的元素都将被删除。如下所示：
>>>a=[0,1,2,3,4,5,6,7]
b=filter(None, a)
>>>print b
>>>[1,2,3,4,5,6,7]

+ map()  和 filter() 很像只是不判断true
Format: map(function, sequence)
iterate所有的sequence的元素並將傳入的function作用於元素，最後以List作為回傳值。
請參考下面例子:

>>> a = [1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> def fn(x):
...     return x*2
>>> c = map(fn, a)
>>> c
[2, 4, 6, 8, 10, 12, 14, 16, 18]

+ lambda()

lambda：这是Python支持一种有趣的语法，它允许你快速定义单行的最小函数，类似与C语言中的宏，这些叫做lambda的函数，是从LISP借用来的，可以用在任何需要函数的地方： 
> g = lambda x: x * 2 
> g(3) 
6 
-------------
def lambda(x)
    return x *2 
g = lambda
------------
> (lambda x: x * 2)(3) 
6

> 如果函数有多个()的话，函数 会把参数以此向前传
+ callable()
callable 函数接收一个对象，并当对象可以调用时返回 1 ，其它情况下返回 0 。可调用对象包括函数、类方法，至甚是类本身。
>> import string
>>> string.punctuation           1
'!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
>>> string.join                  2
<function join at 00C55A7C>
>>> callable(string.punctuation) 3
0
>>> callable(string.join)        4
1


+ reduce(function, iterable[, initializer])

def reduce(function, iterable, initializer=None):
    it = iter(iterable)
    if initializer is None:
        try:
            initializer = next(it)
        except StopIteration:
            raise TypeError('reduce() of empty sequence with no initial value')
    accum_value = initializer
    for x in it:
        accum_value = function(accum_value, x)
    return accum_value

Format: reduce(function, sequence)
必須傳入一個binary function(具有兩個參數的函式)，最後僅會回傳單一值。
reduce會依序先取出兩個元素，套入function作用後的回傳值再與List中的下一個元素一同作為參數，以此類推，直到List所有元素都被取完。
請參考下面例子:

>>> a = [1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> def fn(x, y):
...     return x+y
>>> d = reduce(fn, a)
>>> d
45

下面的圖片輔助說明上面範例程式中的reduce()是如何作用的:
![图片](https://az787680.vo.msecnd.net/user/law1009/1307/20137915243578.png)


+ fabric中载入代码理解

  # loading:
  execfile('fabfile')
  cmds = dict([n for n in filter(lambda n: (n[0][0] != '_') and callable(n[1]), locals().items())])

> 这段代码的意思是 执行fabfile文件 把其中可调用方法载入 并 过滤掉私有方法 ，可调用方法包括 类 函数 等
> cmds  = dict([("对象名"，”对象“)，("对象名"，”对象“)])
> cmds = {'staging': <function staging at 0x7f83e0fccd70>, 'deploy': <function deploy at 0x7f83e0fcce60>}

 上面的代码的 笨蛋写法如下：
----
def lambda1(n):
    return (n[0][0] != '_') and callable(n[1])
    #找出不是以"_"开头的私有方法  并且这个方法是可以调用的，可调用包括函数，类

execfile('fabfile')

aa = locals().items()
bb = filter(lambda1, aa)
cc = [n for n in bb]
cmds = dict(cc)

print cmds
----
其中：
execfile('fabfile')
aa = locals().items()

  #把fabfile 中的 类 函数 变量获得  存入list中
  #[ ('Student', <class __main__.Student at 0x7f83e0fc6390>),('setup', <function setup at 0x7fe5f1ec1de8>),
   ('production', <function production at 0x7fe5f1ec1cf8>)，('x','ccc')]
  #如上，
  #类 ('Student', <class __main__.Student at 0x7f83e0fc6390>)
  #函数 ('setup', <function setup at 0x7fe5f1ec1de8>)
  #变量 ('x','ccc')

+ fabric能执行代码就是这句
  # execution:
  for cmd in args:  #核心 能直接执行函数 靠的就是这个
    cmds[cmd]()

+ 字典赋值方式

def set(**variables):
  "Set a number of Fabric environment variables."
  for k, v in variables.items():
    ENV[k] = (v % ENV)

+ 清理 .gitignore中现有的文件

def clean():
    "Recurse the directory tree and remove all files matched by .gitignore."
    # passing -delete to find doesn't work for directories, hence xargs rm -r
    local('cat .gitignore | xargs -I PATTERN '
        + 'find . -name PATTERN -not -path "./.git/*" | xargs rm -r')

+ _lazy_format() 注释
def _lazy_format(string):
    "Do string substitution of ENV vars - both lazy and earger."
    suber = re.compile(r'\$\((?P<var>\w+?)\)')
    string = string % ENV # early earger  ## 匹配%(ENV_key)s  替换为 ENV_value
    string = re.sub(suber, lambda m: ENV[m.group('var')], string) # 使用正则 把 $(ENV_key) 替换为 ENV_value
    string = string % ENV # late earger
    return string

_lazy_format 实现懒汉模式，直接引用ENV字典中的变量 支持%(ENV_key)s    与 $(ENV_key)  两种写法



