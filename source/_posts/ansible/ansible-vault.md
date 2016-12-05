# ansible-加密-ansible-vault的使用

用法：
加密:
ansible-vault encrypt group_vars/all

查看：
ansible-vault view site.yml

解密：
ansible-vault decrypt site.yml

交互输入：
ansible-playbook -i hosts site.yml --tags=jre_install --ask-vault-pass

从文件中读取
ansible-playbook -i hosts site.yml --tags=jre_install  --vault-password-file ~/.vault_pass.txt

参考：
http://ansible-tran.readthedocs.io/en/latest/docs/playbooks_vault.html