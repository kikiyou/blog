# loop_plugins 可以实现 模糊 copy

这个模块 其实依赖于 lookup_plugins

---

# in addition to loop_with_items, the loop that works over a variable, ansible can do more sophisticated looping.

# developer types: these are powered by 'lookup_plugins' should you ever decide to write your own
# see lib/ansible/runner/lookup_plugins/fileglob.py -- they can do basically anything!

- hosts: all
  gather_facts: no

  tasks:

    # this will copy a bunch of config files over -- dir must be created first

    - file: dest=/etc/fooapp state=directory

    - copy: src=$item dest=/etc/fooapp/ owner=root mode=600
      with_fileglob: /playbooks/files/fooapp/* 


