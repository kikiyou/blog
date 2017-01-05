# 开启pipline
---
- hosts: gatewayed
  #become: true
  # become_user: root
  #become_method: su
  # remote_user: root
  gather_facts: no
  vars:
      ansible_ssh_pipelining: yes
  tasks:
  - name: "查询我是哪个用户"
    command: whoami
    register: xx

  - debug: var=xx

  - name: "创建一个文件"
    copy: src=site.yml dest=/tmp/ntp2.conf 

## 性能对比

如上小任务,

不开启pipline : 26.971 total
开启pipline：7.475 total

## 问题
貌似 在pipelining 模式中无法进行 su 切换为root用户
会报错：standard in must be a tty

解决办法：
1. vim /etc/ssh/sshd_config
#PermitRootLogin no
2. 使用root账户 操作，不使用 su切换

## 删除requiretty

+ 手动
    # 开启pipline的问题 在rhel6 中要关闭requiretty，注释或删除
    cat /etc/sudoers  | grep requiretty
    #Defaults    requiretty

+ 自动
- hosts: foo
  pipelining: no
  tasks:
    - lineinfile: dest=/etc/sudoers line='Defaults requiretty' state=absent
      sudo_user: root


## 参考
[参考](http://toroid.org/ansible-ssh-pipelining)