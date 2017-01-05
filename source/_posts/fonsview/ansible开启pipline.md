# ansible开启 代理 + pipline的步骤

1. chmod u+s /usr/bin/sudo
2. vi /etc/sudoers 删除
Defaults    requiretty

3. vi /etc/sudoers  添加
fonsview  ALL=(ALL)       ALL

下面是ansible自动搞定
1. 先使用su 变为root 
2. 开启sudo
3. 使用sudo干活


``` python

-- hosts
[gatewayed]
test2 ansible_host=10.x.x.x	ansible_user=fonsview	ansible_ssh_pass=xxxxx  ansible_port=50000  proxy_ip=219.x.x.x

-- group_vars/gatewayed
ansible_ssh_common_args: '-o ProxyCommand="ssh -p 50000 -W %h:%p -i ~/.ssh/id_rsa.pub fonsview@{{ proxy_ip }}"'

---
- hosts: gatewayed
  become: true
  become_user: root
  become_method: sudo
  # remote_user: root
  gather_facts: no
  vars:
      ansible_ssh_pipelining: true
      ansible_sudo_user: "{{ ansible_user }}" 
      ansible_sudo_pass: "{{ ansible_ssh_pass }}"
  tasks:
  - file: path=/usr/bin/sudo  mode=u+s 
    become_method: su
    vars:
        ansible_ssh_pipelining: no
        ansible_become_pass: "AHxxx*"

  - lineinfile:
      dest: /etc/sudoers
      regexp: '^Defaults    requiretty'
      line: '#Defaults    requiretty'
      state: present
    become_method: su
    vars:
        ansible_ssh_pipelining: no
        ansible_become_pass: "AHxxx"

  - lineinfile: "dest=/etc/sudoers state=present regexp='^fonsview' line='fonsview  ALL=(ALL)       ALL'"
    become_method: su
    vars:
        ansible_ssh_pipelining: no
        ansible_become_pass: "AHxxx"

  - name: "查询我是哪个用户"
    command: whoami
    register: xx

  - debug: var=xx

  - name: "创建一个文件"
    copy: src=site.yml dest=/tmp/ntp2.conf 

```
