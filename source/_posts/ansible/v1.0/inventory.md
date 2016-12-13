# inventory 处理


class Runner(object):

    def __init__(self,
        host_list=C.DEFAULT_HOST_LIST,      # ex: /etc/ansible/hosts, legacy usage
        ）


    self.inventory  = utils.default(inventory, lambda: ansible.inventory.Inventory(host_list))


utils 中

def default(value, function):
    ''' syntactic sugar around lazy evaluation of defaults '''
    if value is None:
        return function()
    return value

## 如果 inventory 存在，就使用inventory变量里面的，如果没有，就调用哪个ansible.inventory.Inventory 函数。


ansible 结构
inventory 目录中 ini.py  是解析 ini文件
script.py 是解析 可执行文件

如果是str 比如： “/etc/ansible/hosts”  进入 ini.py  文件

class InventoryParser（object） 类
        def _parse(self):

        self._parse_base_groups()
        self._parse_group_children()
        self._parse_group_variables()
        return self.groups

解析后返回 三个对象 
{'ungrouped': <ansible.inventory.group.Group object at 0x7f8b7fb65cb0>, 'web': <ansible.inventory.group.Group object at 0x7f8b7fb68950>, 'all': <ansible.inventory.group.Group object at 0x7f8b7fb689b0>}

就是，无分组 ，分组 ，all 


{'127.0.0.1': <ansible.inventory.host.Host object at 0x7fd09cc00c68>}




最后得到
    self.parser = InventoryParser(filename=host_list)
    self.groups = self.parser.groups.values()



print self.parser.hosts
{'127.0.0.1': <ansible.inventory.host.Host object at 0x7fd09cc00c68>}
print self.parser.groups
{'ungrouped': <ansible.inventory.group.Group object at 0x7f8b7fb65cb0>, 'web': <ansible.inventory.group.Group object at 0x7f8b7fb68950>, 'all': <ansible.inventory.group.Group object at 0x7f8b7fb689b0>}

