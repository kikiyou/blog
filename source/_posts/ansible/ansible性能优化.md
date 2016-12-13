# ansible性能优化

如下配置 可以带来性能的提升

[ssh_connection]

# if uncommented, sets the ansible ssh arguments to the following.  Leaving off ControlPersist
# will result in poor performance, so use transport=paramiko on older platforms rather than
# removing it

ssh_args=-o ControlMaster=auto -o ControlPersist=1h -o ControlPath=~/.ssh/sockets/ansible-ssh-%h-%p-%r
#ssh_args=-o PasswordAuthentication=no -o ControlMaster=auto -o ControlPersist=1h -o ControlPath=~/.ssh/sockets/ansible-ssh-%h-%p-%r

PasswordAuthentication=no 明确指定不使用密码认证
# the following makes ansible use scp if the connection type is ssh (default is sftp)

#scp_if_ssh=True



下面是主机配置，推荐上面直接在ansible.cfg中配置
$ vim .ssh/config
　　Host *
　　Compression yes
　　ServerAliveInterval 60
　　ServerAliveCountMax 5
　　ControlMaster auto
　　ControlPath ~/.ssh/sockets/%r@%h-%p
　　ControlPersist 4h