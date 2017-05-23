# ansible delegate_to 任务委派

任务委派就是 在playbook中指定  某任务只在指定的主机上执行


比如
    我要在192.168.1.1 服务器添加一个hosts 记录 "1.1.1.1 www.abc.com" ,同时也要把这个hosts 记录写到192.168.1.2

ansible hosts 192.168.1.1 文件内容
[all]
192.168.1.1

ansible task 文件内容(192.168.1.1.yml)：
---
- name: add host record
shell: "echo "1.1.1.1 www.abc.com" >> /etc/hosts"

- name: add host record
shell: "echo "1.1.1.1 www.abc.com" >> /etc/hosts"
delegate_to: 192.168.1.2
# 添加上面这一行，就可以了



# 如果是委派给localhost  请使用local_action

如下结果一样

tasks:
- name: Get config
get_url: dest=configs/{{ ansible_hostname }} force=yes url=http://{{ ansible_hostname }}/diagnostic/config
delegate_to: localhost
当你委派给本机的时候，还可以使用更快捷的方法local_action，代码如下：
---
- name: Fetch configuration from all webservers
hosts: webservers

tasks:
- name: Get config
local_action: get_url dest=configs/{{ ansible_hostname}}.cfg url=http://{{ ansible_hostname}}/diagnostic/config