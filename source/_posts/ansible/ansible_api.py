#!/usr/bin/python
# -*- coding: utf-8 -*-
# (c) 2012, Michael DeHaan <michael.dehaan@gmail.com>
# example of getting the uptime of all hosts, 10 at a time

import ansible.runner
from ansible.inventory import Inventory
from ansible.inventory.group import Group
from ansible.inventory.host import Host
import sys,json

class MyInventory(Inventory):
    """
    this is my ansible inventory object.
    """
    def __init__(self, resource):
        """
        resource的数据格式是一个列表字典，比如
            {
                "group1": {
                    "hosts": [{"hostname": "10.10.10.10", "port": "22", "username": "test", "password": "mypass"}, ...],
                    "vars": {"var1": value1, "var2": value2, ...}
                }
            }

        如果你只传入1个列表，这默认该列表内的所有主机属于my_group组,比如
            [{"hostname": "10.10.10.10", "port": "22", "username": "test", "password": "mypass"}, ...]
        """
        self.resource = resource
        self.inventory = Inventory(host_list=[])
        self.gen_inventory()

    def my_add_group(self, hosts, groupname, groupvars=None):
        """
        add hosts to a group
        """
        my_group = Group(name=groupname)

        # if group variables exists, add them to group
        if groupvars:
            for key, value in groupvars.iteritems():
                my_group.set_variable(key, value)

        # add hosts to group
        for host in hosts:
            # set connection variables
            hostname = host.get("hostname")
            hostip = host.get('ip', hostname)
            hostport = host.get("port")
            username = host.get("username")
            password = host.get("password")
            ssh_key = host.get("ssh_key")
            my_host = Host(name=hostname, port=hostport)
            my_host.set_variable('ansible_ssh_host', hostip)
            my_host.set_variable('ansible_ssh_port', hostport)
            my_host.set_variable('ansible_ssh_user', username)
            my_host.set_variable('ansible_ssh_pass', password)
            my_host.set_variable('ansible_ssh_private_key_file', ssh_key)

            # set other variables 
            for key, value in host.iteritems():
                if key not in ["hostname", "port", "username", "password"]:
                    my_host.set_variable(key, value)
            # add to group
            my_group.add_host(my_host)

        self.inventory.add_group(my_group)

    def gen_inventory(self):
        """
        add hosts to inventory.
        """
        if isinstance(self.resource, list):
            self.my_add_group(self.resource, 'default_group')
        elif isinstance(self.resource, dict):
            for groupname, hosts_and_vars in self.resource.iteritems():
                self.my_add_group(hosts_and_vars.get("hosts"), groupname, hosts_and_vars.get("vars"))

# construct the ansible runner and execute on all hosts




if __name__ == "__main__":
#   resource =  {
#                "group1": {
#                    "hosts": [{"hostname": "monkey", "hostip":"127.0.0.1","port": "22", "username": "root", "password": "xxx"},],
#                    "vars" : {"var1": "value1", "var2": "value2"},
#                          },
#                }

    # resource = {
    #     "group1": {
    #         "hosts": [{"hostname": "127.0.0.1", "port": "22", "username": "yh", "password": "redhat"}]
    #                 # "ansible_become": "yes",
    #                 # "ansible_become_method": "sudo",
    #                 # # "ansible_become_user": "root",
    #                 # "ansible_become_pass": "yusky0902",
    #              }
    # }
    resource = [{"hostname":"monkey", "ip":"127.0.0.1", "port": '22', "username":"yh", "password": "redhat"}]
    # resource =  {
    #            "group1": {
    #                "hosts": [{"hostname": "monkey", "ip":"127.0.0.1","port": "22", "username": "root", "password": "redhat"}],
    #                "vars" : {"var1": "value1", "var2": "value2"}
    #                      }
    #            }
    myinventory = MyInventory(resource).inventory
    # print myinventory

    results = ansible.runner.Runner(
        pattern='*', forks=10,
        module_name='command', module_args='uptime',
        inventory=myinventory
    ).run()
    # results = json.dumps(res, indent=4)
    # results = res
    # print results
    # print results

    if results is None:
        print "No hosts found"
        sys.exit(1)

    print "UP ***********"
    for (hostname, result) in results['contacted'].items():
        if not 'failed' in result:
            print "%s >>> %s" % (hostname, result['stdout'])

    print "FAILED *******"
    for (hostname, result) in results['contacted'].items():
        if 'failed' in result:
            print "%s >>> %s" % (hostname, result['msg'])

    print "DOWN *********"
    for (hostname, result) in results['dark'].items():
        print "%s >>> %s" % (hostname, result)

