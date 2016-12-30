1. 如果输入的密码过于简单，报错密码验证不通过可以
Your password does not satisfy the current policy requirements
[root@db1 ~]#vim ~/my.cnf
validate-password = off

2. Warning: Using a password on the command line interface can be insecure.
比如：
如下:
[root@db1 ~]# mysql -uappuser -pappuser -e "show databases;"
mysql: [Warning] Using a password on the command line interface can be insecure.

解决办法1：
[root@db1 ~]#mysql_config_editor set --user=root --password
Enter password: 

上面文件会创建如下加密文件
[root@db1 ~]# cat ~/.mylogin.cnf 

               ��u�q:������eƃ��>�C�R��U ��:=:M5&3��7�-<��jU�Q	�uK�P�
[root@db1 ~]# mysql_config_editor print --all
[client]
user = root
password = *****

这时，输入mysql命令时可不输入密码直接执行：

[root@db1 ~]# mysql -e "show databases;"
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| ossdb              |
| performance_schema |
| sys                |
解决办法2：
创建明文:
[root@monkey-2 ~]# cat ~/.my.cnf
[client]
host= localhost
user = root
password = 1234

结果同上:

mysql_config_editor set --login-path=remote --host=remote --user=remote --password

[vagrant@localhost ~]$ mysql_config_editor set --login-path=remote --host=remote --user=remote --password
Enter password:secure
[vagrant@localhost ~]$ mysql_config_editor print --all
[client]
user = root
password = *****
[remote]
user = remote
password = *****
host = remote
[vagrant@localhost ~]$ mysql --login-path=remote