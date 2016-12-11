## ansible 模板中字符串格式化

ansible 中引用jinja2 中的字符串格式化format_advanced() ,来做格式化
而 format_advanced() 来源于python自带的string 中的 formatstrings方法

>>> '{2}, {1}, {0}'.format('a', 'b', 'c')
'c, b, a'



template --》model

environment = jinja2.Environment()

def format_advanced(fmt, data):
    # jinja2 filter to use advanced python string formatting
    # e.g, {{ "{0} {1} {2}"|format_advanced(['a', 'b', 'c']) }}
    # see http://docs.python.org/library/string.html#formatstrings
    if isinstance(data, collections.Mapping):
        return fmt.format(**data)
    elif isinstance(data, collections.Sequence):
        return fmt.format(*data)
    else:
        return data

environment.filters['format_advanced'] = format_advanced

template = environment.from_string(source)
