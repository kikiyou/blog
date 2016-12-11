把表达式 当成变量存储 ，only_if 动作 去解析 执行


ansible 中变量 可以 组合
      - role: foo
        param1: '{{ foo }}'
        param2: '{{ some_var1 + "/" + some_var2 }}'
        when: ansible_os_family == 'RedHat'


SHA e6406fa5
``` python
  vars:
     favcolor: "red"
     ssn: 8675309
     is_favcolor_blue: "'$favcolor' == 'blue'"
#     is_centos: "'$facter_operatingsystem' == 'CentOS'"

  tasks:

     - name: "do this if my favcolor is blue"
       action: shell /bin/false
       only_if: '$is_favcolor_blue'

```
### 实现方式
这种神奇的方式，在ansible中是这样实现的
1. 调用double_template  对变量进行两层替换
2. 对替换的结果 执行eval

runner.py v0.0.2 中
``` python
    def _execute_module(self, conn, tmp, remote_module_path, args, 
        async_jid=None, async_module=None, async_limit=None):
        ''' runs a module that has already been transferred '''

        inject = self.setup_cache.get(conn.host,{})
        conditional = utils.double_template(self.conditional, inject)
        if not eval(conditional):
            return [ utils.smjson(dict(skipped=True)), None, 'skipped' ]
```

#host file
[staging]
staging.myproject.com nickname=staging vm=0 branch=develop

#playbook
  vars:
     favcolor: "red"
     dog: "fido"
     cat: "whiskers"
     ssn: 8675309

  - name: Upload SSH key.
    copy: src=key dest={{ project_root }}/home/.ssh/id_rsa mode=0600
    only_if: "$vm == 0"

  - name: "do this if my favcolor is blue, and my dog is named fido"
    action: shell /bin/false
    when_string: $favcolor == 'blue' and $dog == 'fido'


# These are the types of when statemnets available
#     when_set: $variable_name
#     when_unset: $variable_name
#     when_str: $x == "test"
#     when_int: $y > 2
#     when_float: $z => 2.3