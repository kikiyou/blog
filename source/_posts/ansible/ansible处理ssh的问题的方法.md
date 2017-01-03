1. 使用普通用户连接，然后自动切换为root 执行操作

方法一： 不知道root账户密码的情况，使用sudo
在hosts中配置
[tests]
monkey_1 ansible_host=xx.xx.xx.xx	ansible_user=fonsview	ansible_ssh_pass="fonsview用户密码"  ansible_port=50000 ansible_sudo_user="{{ ansible_ssh_pass }}" ansible_sudo_pass="{{ ansible_ssh_pass }}"

在playbook中设置become 参数
- hosts: tests
  become: true
  become_user: root   （可省略,默认用户root）
  become_method: sudo  （可省略，默认切换方式sudo）
  gather_facts: no
  tasks:
  - name: "查询我是哪个用户"
    command: whoami
    register: xx

  - debug: var=xx

方法二： 知道root账户密码的情况
在hosts中配置
[tests]
monkey_1 ansible_host=xx.xx.xx.xx	ansible_user=fonsview	ansible_ssh_pass="fonsview用户密码"  ansible_port=50000 ansible_become_pass="root账户密码"

在playbook中设置become 参数
- hosts: tests
  become: true
  become_user: root （可省略,默认用户root）
  become_method: su
  gather_facts: no
  tasks:
  - name: "查询我是哪个用户"
    command: whoami
    register: result

  - debug: var=result


http://stackoverflow.com/questions/31408017/ansible-with-a-bastion-host-jump-box
2. ansible的跨主机 操作实现  A -> B ->  C  ansible可直接向C发送命令

主机配置
[gatewayed]
foo ansible_host=192.0.2.1
bar ansible_host=192.0.2.2
创建 group_vars/gatewayed.yml 文件，包含如下内容
ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p -q user@gateway.example.com"'

这样ansible 操作属于gatewayed组的主机，可自动先登录跳板主机，然后再跳转到 生产主机 执行命令