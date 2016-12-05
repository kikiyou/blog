把表达式 当成变量存储 ，only_if 动作 去解析 执行


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