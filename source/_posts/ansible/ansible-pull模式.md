#ansible-pull 模式

ansible-pull 是ansible提供的一个命令 

是为了大规模 可持续部署而设置的简单方式


传统的我们使用ansible 是在push模式，就是 我们把我们的配置推送到远程主机

现在 ansible 支持 pull模式

$ ansible-pull -U https://github.com/training-devops/ansible-pull-example -i <path_to_inventory>


可以设置定时任务，让ansible自动 去git仓库中下载内容，如果git仓库有改变，
自动执行 对应的 inventory 和对应的playbook



$cat inventory 
[local]
127.0.0.1

$cat local.yml
---
- hosts: local

  tasks:
  - name: install vim
    dnf: pkg=vim state=installed



yh ➜  cc ansible-pull -U https://github.com/training-devops/ansible-pull-example -i /etc/ansible/hosts
Starting ansible-pull at 2016-12-11 18:02:42
localhost | success >> {
    "after": "70339e8d7f435272e99798de9b004b10ccd7cd10", 
    "before": "70339e8d7f435272e99798de9b004b10ccd7cd10", 
    "changed": false
}


PLAY [local] ****************************************************************** 

GATHERING FACTS *************************************************************** 
ok: [127.0.0.1]

TASK: [install vim] *********************************************************** 
