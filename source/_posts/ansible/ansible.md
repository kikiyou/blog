---
title: ansible 源码学习
date: 2016-09-30 10:19:44
tags: 
- ansible
- python
---

# ansible 源码学习
<!-- more -->
+ fnmatch   unix文件匹配模块
import fnmatch
import os

for file in os.listdir('.'):
    if fnmatch.fnmatch(file, '*.txt'):
        print file
----output
cc.txt
requirements.txt
contributors.txt

+ facter

dnf install facter
/usr/bin/facter --json

输出主机的常见信息

+  创建临时目录
mktemp /tmp/vvv.XXXXXX


+ itertools 高效循环的迭代函数集合
[参考](http://wklken.me/posts/2013/08/20/python-extra-itertools.html)

+ multiprocessing

因为众所周之的的python多线程全局锁的性能问题，ansible并发使用的是多进程实现 fork=X。

[multiprocessing](http://www.cnblogs.com/vamei/archive/2012/10/12/2721484.html)

+ 并发

http://stackoverflow.com/questions/3288595/multiprocessing-using-pool-map-on-a-function-defined-in-a-class

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
并发的执行 函数  和 参数，并且返回结果都可以返回
ansible 使用这个特性，来并发执行命令 参数为对应的hosts

+ ansibel patterns - 模式匹配，允许多个匹配规则
全部匹配到才是匹配
['*.rhel.cc','web']   --> web1.rel.cc 

+ ansible 模版的setup模块中 
 变量格式是json
 指定了matedata 就从matedata中读取变量，否则使用/etc/ansible/setup 中的，
 后改为 ～/.ansible/setup 下

 +  变化

 play_book 中的变量，由明确指定到寸放在vars 中

 action: setup http_port=80 max_clients=200
 ----
 
vars:
    http_port: 80
    max_clients: 200

+ ansible的思想很简单

    主要想法是：

    使用多进程的方式调用paramiko 来进行ssh连接，

    然后把 把预先定义好的模块（比如 ping）传到远程主机，

    再调用paramiko.exec_command,加参数执行之。

    后来play_book 之类的都是在这个思想上的延伸。

+ ansible 0.0.1 之后 增加了自定义 错误的功能
  写在errors.py 中  from ansible.errors import * 引入

+ ansibel 中把 参数的传递，改为写参数文件，传递给remote
生产的文件如：(6, '/tmp/tmpKFllwL')
        # make a tempfile for the args and stuff the args into the file
        argsfd,argsfile = tempfile.mkstemp()
        argsfo = os.fdopen(argsfd, 'w')
        argsfo.write(args)
        argsfo.flush()
        argsfo.close()
        args_rem = tmp + 'argsfile'
        self.remote_log(conn, "args: %s" % args)
        self._transfer_file(conn,argsfile, args_rem)
        os.unlink(argsfile)
        cmd = "%s %s" % (remote_module_path, args_rem)
由传参数，改为传参数文件的路径

+ ansibel 中支持返回的不是json的兼容
只要返回的是key=value 这种形式就可以
```
def parse_json(data):
    try:
        return json.loads(data)
    except:
        # not JSON, but try "Baby JSON" which allows many of our modules to not
        # require JSON and makes writing modules in bash much simpler
        results = {}
        tokens = shlex.split(data)
        for t in tokens:
            if t.find("=") == -1:
                raise AnsibleException("failed to parse: %s" % data)
            (key,value) = t.split("=", 1)
            if key == 'changed' or 'failed':
                if value.lower() in [ 'true', '1' ] :
                    value = True
                elif value.lower() in [ 'false', '0' ]:
                    value = False
            if key == 'rc':
                value = int(value)     
            results[key] = value
        return results
```

+ ansible 由test-mode 脚本 可以不用ansible 直接调用脚本来执行

<!-- SHA 63818000 -->
+ 在runner.py 中，copy/template 之后自动调用 file模块

 这样可以在copy/template 之后自动改变文件的权限等

 <!-- SHA 9f6d9884 -->
 + 如果host文件是可执行的，将其视为返回JSON文件。
  
   1. 如果直接调用，则返回host和group list。
   2. 如果使用host name的参数调用，则返回匹配到的特定的 k=v 数据

``` python
            host_list = os.path.abspath(host_list)
            cls._external_variable_script = host_list
            # it's a script -- expect a return of a JSON hash with group names keyed
            # to lists of hosts
            cmd = subprocess.Popen([host_list], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
            out, err = cmd.communicate()
            try:
                groups = json.loads(out)
            except:
                raise AnsibleError("invalid JSON response from script: %s" % host_list)
            for (groupname, hostlist) in groups.iteritems():
                for host in hostlist:
                    if host not in results:
                        results.append(host)

        return (results, groups)
```

+ evn-setup
当你不想安装ansible 而直接执行 ansible 时 ，可以运行下面shell 脚本实现
``` bash
#!/bin/bash
# usage: source ./hacking/env-setup
#    modifies environment for running Ansible from checkout

PREFIX_PYTHONPATH="$PWD/lib"
PREFIX_PATH="$PWD/bin"

export PYTHONPATH=$PREFIX_PYTHONPATH:$PYTHONPATH
export PATH=$PREFIX_PATH:$PATH
export ANSIBLE_LIBRARY="$PWD/library"

echo "PATH=$PATH"
echo "PYTHONPATH=$PYTHONPATH"
echo "ANSIBLE_LIBRARY=$ANSIBLE_LIBRARY"

echo "reminder: specify your host file with -i"
echo "done."
```

<!-- SHA 5ed2b894 -->
+  在模板文件中，$foo 这样的会被替换成，会被替换成 字典中的value

$port 和 {{ port }} 的写法相同


- name: test basic shell, plus two ways to dereference a variable
action: shell echo $HOME $port {{ port }}

``` python
_KEYCRE = re.compile(r"\$(\w+)")

def varReplace(raw, vars):
    '''Perform variable replacement of $vars

    @param raw: String to perform substitution on.  
    @param vars: Dictionary of variables to replace. Key is variable name
        (without $ prefix). Value is replacement string.
    @return: Input raw string with substituted values.
    '''
    # this code originally from yum

    done = []                      # Completed chunks to return

    while raw:
        m = _KEYCRE.search(raw)
        if not m:
            done.append(raw)
            break

        # Determine replacement value (if unknown variable then preserve
        # original)
        varname = m.group(1).lower()
        replacement = vars.get(varname, m.group())

        start, end = m.span()
        done.append(raw[:start])    # Keep stuff leading up to token
        done.append(replacement)    # Append replacement value
        raw = raw[end:]             # Continue with remainder of string

    return ''.join(done)

def template(text, vars):
    ''' run a text buffer through the templating engine '''
    text = varReplace(text, vars)
    template = jinja2.Template(text)
    return template.render(vars)
```

+ ansible 中直接调用remote 主机的命令

- name: Execute network report
  shell: chdir=/usr/bin mysql -u root --password={{ MYSQLPASS }} --table < /usr/share/network_report.sql >> {{ REPORT_DIR }}/os_report_{{ lookup('pipe', 'date +%Y%m%d') }}.log