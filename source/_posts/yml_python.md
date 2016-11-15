---
title: yml与python格式之间的转换
date: 2016-07-18 16:10:02
tags: 
- python
---
# yml与python格式之间的转换
<!-- more -->
[参考](http://www.ruanyifeng.com/blog/2016/07/yaml.html)


## python 读取yaml

import  yaml
playbook='/tmp/test.yaml'
playbook = yaml.load(file(playbook).read())


## yaml 与 pyton格式
+ 键盘值对

yml：
    animal：pets
    foo：bar

    { name: Steve, foo: bar }

python：字典
    {
        'name': 'Steve',
        'foo': 'bar'
    }

+ 数组

yml:
- Cat
- Dog
- Goldfish

python:列表
    ['Cat','Dog','Goldfish']

+ 符合结构

yml：
    languages:
        - Ruby
        - Perl
        - Python 
    websites:
        YAML: yaml.org 
        Ruby: ruby-lang.org 
        Python: python.org 
        Perl: use.perl.org 

python：
    {
        'languages':['Ruby','Perl','Python'],
        'websites':{ YAML: 'yaml.org', Ruby: 'ruby-lang.org', Python: 'python.org ',Perl: 'use.perl.org' }
     } 



+ 真实文件

- pattern: '*'
  tasks:
  - do:
    - configure template & module variables
    - setup a=2 b=3 c=4
  - do:
    - copy a file
    - copy /srv/a /srv/b
    notify: 
    - restart apache
  - do:
    - template from local file template.j2 to remote location /srv/file.out
    - template /srv/template.j2 /srv/file.out
    notify:
    - restart apache
    - quack like a duck
  handlers:
    - do:
      - restart apache
      - command /sbin/service httpd restart
    - do:
      - quack like a duck
      - command /bin/true



python：

[{
    'handlers': [
        {'do': ['restart apache','command /sbin/service httpd restart']},
        {'do': ['quack like a duck', 'command /bin/true']}
        ],
  'pattern': '*',
  'tasks': [
      {'do': ['configure template & module variables','setup a=2 b=3 c=4']},
      {'do': ['copy a file', 'copy /srv/a /srv/b'], 'notify': ['restart apache']},
      {'do': ['template from local file template.j2 to remote location /srv/file.out','template /srv/template.j2 /srv/file.out'],'notify': ['restart apache', 'quack like a duck']}
        ]
    }
]
