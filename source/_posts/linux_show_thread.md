---
title: linux下多线程查看工具
tags: 
- linux
---
#linux下多线程查看工具
<!-- more -->
* pstree

``` bash
[root@fedora]~# pstree  -p dawx
bash(17676)───python3.4(18015)─┬─{python3.4}(18016)
                               └─{python3.4}(18017)
bash(17934)
```

> pstree 树状显示ps
> -p 显示进程号
> dawx 要查看那个用户下的线程情况

``` bash
[root@fedora]~# ll /proc/18015
总用量 0
dr-xr-xr-x. 2 dawx dawx 0 10月 16 21:19 attr
-rw-r--r--. 1 dawx dawx 0 10月 16 21:19 autogroup
-r--------. 1 dawx dawx 0 10月 16 21:19 auxv
-r--r--r--. 1 dawx dawx 0 10月 16 21:19 cgroup
--w-------. 1 dawx dawx 0 10月 16 21:19 clear_refs
-r--r--r--. 1 dawx dawx 0 10月 16 21:19 cmdline
-rw-r--r--. 1 dawx dawx 0 10月 16 21:19 comm
-rw-r--r--. 1 dawx dawx 0 10月 16 21:19 coredump_filter
-r--r--r--. 1 dawx dawx 0 10月 16 21:19 cpuset
lrwxrwxrwx. 1 dawx dawx 0 10月 16 21:19 cwd -> /tmp
-r--------. 1 dawx dawx 0 10月 16 21:19 environ
lrwxrwxrwx. 1 dawx dawx 0 10月 16 21:19 exe -> /usr/bin/python3.4
```

* pstack

``` bash
[root@fedora]~# pstack 18015   
Thread 3 (Thread 0x7fe7863fc700 (LWP 18016)):
#0  0x00007fe78d050ea3 in select () from /lib64/libc.so.6
#1  0x00007fe78640075c in time_sleep () from /usr/lib64/python3.4/lib-dynload/time.cpython-34m.so
#2  0x00007fe78dd59651 in PyEval_EvalFrameEx () from /lib64/libpython3.4m.so.1.0
#3  0x00007fe78dd5a636 in PyEval_EvalCodeEx () from /lib64/libpython3.4m.so.1.0
#4  0x00007fe78dcca728 in function_call () from /lib64/libpython3.4m.so.1.0
#5  0x00007fe78dca1db1 in PyObject_Call () from /lib64/libpython3.4m.so.1.0
#6  0x00007fe78dd51037 in PyEval_CallObjectWithKeywords () from /lib64/libpython3.4m.so.1.0
#7  0x00007fe78dd92852 in t_bootstrap () from /lib64/libpython3.4m.so.1.0
#8  0x00007fe78da2960a in start_thread () from /lib64/libpthread.so.0
#9  0x00007fe78d05abbd in clone () from /lib64/libc.so.6
Thread 2 (Thread 0x7fe785bfb700 (LWP 18017)):
#0  0x00007fe78d050ea3 in select () from /lib64/libc.so.6
#1  0x00007fe78640075c in time_sleep () from /usr/lib64/python3.4/lib-dynload/time.cpython-34m.so
#2  0x00007fe78dd59651 in PyEval_EvalFrameEx () from /lib64/libpython3.4m.so.1.0
#3  0x00007fe78dd5a636 in PyEval_EvalCodeEx () from /lib64/libpython3.4m.so.1.0
#4  0x00007fe78dcca728 in function_call () from /lib64/libpython3.4m.so.1.0
#5  0x00007fe78dca1db1 in PyObject_Call () from /lib64/libpython3.4m.so.1.0
#6  0x00007fe78dd51037 in PyEval_CallObjectWithKeywords () from /lib64/libpython3.4m.so.1.0
#7  0x00007fe78dd92852 in t_bootstrap () from /lib64/libpython3.4m.so.1.0
#8  0x00007fe78da2960a in start_thread () from /lib64/libpthread.so.0
#9  0x00007fe78d05abbd in clone () from /lib64/libc.so.6
Thread 1 (Thread 0x7fe78e2d1700 (LWP 18015)):
#0  0x00007fe78d050ea3 in select () from /lib64/libc.so.6
#1  0x00007fe78640075c in time_sleep () from /usr/lib64/python3.4/lib-dynload/time.cpython-34m.so
#2  0x00007fe78dd59651 in PyEval_EvalFrameEx () from /lib64/libpython3.4m.so.1.0
#3  0x00007fe78dd58e4b in PyEval_EvalFrameEx () from /lib64/libpython3.4m.so.1.0
#4  0x00007fe78dd5a636 in PyEval_EvalCodeEx () from /lib64/libpython3.4m.so.1.0
#5  0x00007fe78dd5a6db in PyEval_EvalCode () from /lib64/libpython3.4m.so.1.0
#6  0x00007fe78dd76954 in run_mod () from /lib64/libpython3.4m.so.1.0
#7  0x00007fe78dd78b95 in PyRun_FileExFlags () from /lib64/libpython3.4m.so.1.0
#8  0x00007fe78dd79c13 in PyRun_SimpleFileExFlags () from /lib64/libpython3.4m.so.1.0
#9  0x00007fe78dd90964 in Py_Main () from /lib64/libpython3.4m.so.1.0
#10 0x000056097477abe7 in main ()
```

+ proc
cat /proc/18015/status
Threads:	3

> 如上可知，有三个线程工作