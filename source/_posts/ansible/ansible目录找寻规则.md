# ansible 文件/目录找寻规则

主要是  path_dwim 这里定义的

如果不是 依‘/’ '~/' 这样开头的  都走相对路径模式
由 basedir +  given  组合路径


def path_dwim(basedir, given):
    ''' make relative paths work like folks expect '''
    if given.startswith("/"):
        return given
    elif given.startswith("~/"):
        return os.path.expanduser(given)
    else:
        return os.path.join(basedir, given)