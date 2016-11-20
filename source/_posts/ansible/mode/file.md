#  file 模块学习

* file模块有三种状态，[file', 'directory', 'absent']

* file模块中change状态的传递

1. 默认changed 是false
2. 当一个changed 是true时 changed就是true
3. 如果函数中没有改变，就把接收的上一个changed 返回
4. 这样保证 只要一个函数中返回true 最终就是true

changed = false
 # set modes owners and context as needed
    changed = set_context_if_different(path, secontext, changed)
    changed = set_owner_if_different(path, owner, changed)
    changed = set_group_if_different(path, group, changed)
    changed = set_mode_if_different(path, mode, changed)


* file 文件的报错信息

yh ➜  source_read ansible localhost -m file -a "src=/tmp/ dest=/path/to/symlink owner=foo group=foo state=link"
localhost | FAILED >> {
    "failed": true, 
    "msg": "Error while linking: [Errno 2] No such file or directory", 
    "path": "/path/to/symlink", 
    "state": "absent"
}

yh ➜  source_read ansible localhost -m file -a "src=/tmp/ dest=/cc owner=foo group=foo state=link"
localhost | FAILED >> {
    "failed": true, 
    "msg": "Error while linking: [Errno 13] Permission denied", 
    "path": "/cc", 
    "state": "absent"
}
