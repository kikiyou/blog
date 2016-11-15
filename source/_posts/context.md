---
title: contextmanager
date: 2016-07-14 10:19:44
tags:
---
### 关于with和contextmanager
<!-- more -->
+ whith的使用
 - 术语

    要使用 with 语句，首先要明白上下文管理器这一概念。

    有了上下文管理器，with 语句才能工作。

    下面是一组与上下文管理器和with 语句有关的概念。

    上下文管理协议（Context Management Protocol）：

    包含方法 `__enter__()` 和 `__exit__()`，支持该协议的对象要实现这两个方法。
<!-- more -->
    上下文管理器（Context Manager）：

    支持上下文管理协议的对象，这种对象实现了

    `__enter__()` 和 `__exit__()` 方法。上下文管理器定义执行 with 语句时要建立的运行时上下文，负责执行 with 语句块上下文中的进入与退出操作。通常使用 with 语句调用上下文管理器，也可以通过直接调用其方法来使用。

    运行时上下文（runtime context）：

    由上下文管理器创建，通过上下文管理器的 `__enter__()` 和`__exit__()` 方法实现，`__enter__()` 方法在语句体执行之前进入运行时上下文，`__exit__()` 在语句体执行完后从运行时上下文退出。with 语句支持运行时上下文这一概念。

    上下文表达式（Context Expression）：

    with 语句中跟在关键字 with 之后的表达式，该表达式要返回一个上下文管理器对象。

    语句体（with-body）：

    with 语句包裹起来的代码块，在执行语句体之前会调用上下文管理器的 `__enter__()` 方法，执行完语句体之后会执行 `__exit__()` 方法。

 - 通俗解释

    一个**类**只要写有 `__enter__()` 和 `__exit__()`方法，就说明支持运行时上下文，使用whit 可以调用它。
 - 使用场景

    有一些任务，可能事先需要设置，事后做清理工作，这时就可以使用with了。

    执行流程是：
    1. 先调用`__enter__()`方法
    2. 执行whith中的内容
    3. 调用`__exit__()`方法

+ with基本语法和工作原理

    下面使用读取文件作为示例
    1. 不用with语句
    ``` python
    file = open("/tmp/foo.txt")
    data = file.read()
    file.close()
    ```
    这里有两个问题:

    (1) 是可能忘记调用close关闭文件句柄；

    (2) 是文件读取数据发生异常，没有进行任何处理。
    2. 使用try ... finally    file.read()无论结果如何 都回执行finally
    ``` python
    file = open("/tmp/foo.txt")
    try:
        data = file.read()
    finally:
        file.close()
    ```
    3. 使用with的版本
    ``` python
    with open("/tmp/foo.txt") as file:
        data = file.read()
    ```
    除了有更优雅的语法，with还可以很好的处理上下文环境产生的异常。

    如下说明了 with的执行流程
    ``` python
    >>> f = open("x.txt")
    >>> f
    <open file 'x.txt', mode 'r' at 0x00AE82F0>
    >>> f.__enter__()
    <open file 'x.txt', mode 'r' at 0x00AE82F0>
    >>> f.read(1)
    'X'
    >>> f.__exit__(None, None, None)
    >>> f.read(1)
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    ValueError: I/O operation on closed file
    ```
+ contextmanager的使用
    - 创建上下文管理
    ``` python
    class Context(object):

    def __init__(self, handle_error):
        print '__init__(%s)' % handle_error
        self.handle_error = handle_error

    def __enter__(self):
        print '__enter__()'
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        print '__exit__(%s, %s, %s)' % (exc_type, exc_val, exc_tb)
        return self.handle_error

    with Context(True):
        raise RuntimeError('error message handled')

    print

    with Context(False):
        raise RuntimeError('error message propagated')
    ```
    执行结果
    ``` python
    $ python contextlib_api_error.py

    __init__(True)
    __enter__()
    __exit__(<type 'exceptions.RuntimeError'>, error message handled, <traceback object at 0x10046a5f0>)

    __init__(False)
    __enter__()
    __exit__(<type 'exceptions.RuntimeError'>, error message propagated, <traceback object at 0x10046a680>)
    Traceback (most recent call last):
      File "contextlib_api_error.py", line 30, in <module>
        raise RuntimeError('error message propagated')
    RuntimeError: error message propagated
    ```

    上面列出了传统的创建上下文的方法，前提是你要先定义**类**，并且要提前定义`__enter__()` 和 `__exit__()`方法，比较麻烦。

    **python 官方提供了contextlib模块作为上下文管理工具**
    小例子看下它怎么用
    ``` python
    from contextlib import contextmanager

    @contextmanager
    def tag(name):
        print("<%s>" % name)
        yield
        print("</%s>" % name)

    >>> with tag("h1"):
    ...    print("foo")
    ...
    <h1>
    foo
    </h1>
    ```
    如下示例：打开一个文件，确保文件关闭
    ``` python
    from contextlib import contextmanager
    @contextmanager
    def opened(filename, mode="r"):
        f = open(filename, mode)
        try:
            yield f
        finally:
            f.close()
    按照如下方法使用：
    with opened("/etc/passwd") as f:
    for line in f:
        print line.rstrip()

    ```
    如下示例： 提交或回滚一个数据库
    ``` python
    @contextmanager
    def transaction(db):
        db.begin()
        try:
            yield None
        except:
            db.rollback()
            raise
        else:
            db.commit()
    ```
    - contextlib.closing(thing)的使用
    closing的作用其实就是，最后调用类中提前定义的close方法
    closing的基本实现如下：
    ``` python
    from contextlib import contextmanager

    @contextmanager
    def closing(thing):
        try:
            yield thing
        finally:
            thing.close()
    ```
    使用方法如下
    ``` python
    from contextlib import closing
    from urllib.request import urlopen

    with closing(urlopen('http://www.python.org')) as page:
        for line in page:
            print(line)
    ```
    Python 3.2 中新增 contextlib.ContextDecorator，
    可以允许我们自己在 class 层面定义新的”上下文管理修饰器“。
    ``` python
    from contextlib import ContextDecorator

    class mycontext(ContextDecorator):
        def __enter__(self):
            print('Starting')
            return self

        def __exit__(self, *exc):
            print('Finishing')
            return False

    >>> @mycontext()
    ... def function():
    ...     print('The bit in the middle')
    ...
    >>> function()
    Starting
    The bit in the middle
    Finishing

    >>> with mycontext():
    ...     print('The bit in the middle')
    ...
    Starting
    The bit in the middle
    Finishing

    This change is just syntactic sugar for any construct of the following form:

    def f():
        with cm():
            # Do stuff
    ContextDecorator lets you instead write:

    @cm()
    def f():
        # Do stuff
    ```
    参考：

    https://pymotw.com/2/contextlib/

    https://www.python.org/dev/peps/pep-0343/

    https://docs.python.org/3/library/contextlib.html
