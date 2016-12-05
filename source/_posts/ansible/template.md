# ansible template 模块讲解


如果 在playbook中使用 template命令的话  

ansible会在 ansible runner.py 文件中如下方式 调用 _execute_template 函数

注：至少在v0.0.2 版本的 template命令 依赖于 客户端 需要jinja2 支持

``` python
 runner.py 版本v0.0.2 -------------
        elif self.module_name == 'template':
            result = self._execute_template(conn, host, tmp)
                     -------------
    def _execute_template(self, conn, host, tmp):
        ''' handler for template operations '''

        # load up options
        options  = self._parse_kv(self.module_args)
        source   = options['src']
        dest     = options['dest']
        metadata = options.get('metadata', None)

        if metadata is None:
            if self.remote_user == 'root':
                metadata = '/etc/ansible/setup'
            else:
                metadata = '~/.ansible/setup'

        # first copy the source template over
        tpath = tmp## 随机路径 比如:~/.ansible/xxx_temp_1234/
        tempname = os.path.split(source)[-1]  #源文件 比如 nginx.conf.j2
        temppath = tpath + tempname  #组合后 为：~/.ansible/xxx_temp_1234/nginx.conf.j2
        self._transfer_file(conn, utils.path_dwim(self.basedir, source), temppath)

        # install the template module
        template_module = self._transfer_module(conn, tmp, 'template')

        # run the template module
        #先执行 template_module  
        args = [ "src=%s" % temppath, "dest=%s" % dest, "metadata=%s" % metadata ]
        (result1, executed) = self._execute_module(conn, tmp, template_module, args)
        results1 = self._return_from_module(conn, host, result1, executed)
        (host, ok, data) = results1

        ###如果 template module 执行正常，再调用file，模块修改相关权限
        # magically chain into the file module
        if ok:
            # unless failed, run the file module to adjust file aspects
            old_changed = data.get('changed', False)
            module = self._transfer_module(conn, tmp, 'file')
            args = [ "%s=%s" % (k,v) for (k,v) in options.items() ]
            (result2, executed2) = self._execute_module(conn, tmp, module, args)
            results2 = self._return_from_module(conn, host, result2, executed)
            (host, ok, data2) = results2
            new_changed = data2.get('changed', False)
            data.update(data2)
            if old_changed or new_changed:
                data['changed'] = True
            return (host, ok, data)
        else:
            # copy failed, return orig result without going through 'file' module
            return results1
```