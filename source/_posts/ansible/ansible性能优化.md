# ansible性能优化

如下配置 可以带来性能的提升

[ssh_connection]

# if uncommented, sets the ansible ssh arguments to the following.  Leaving off ControlPersist
# will result in poor performance, so use transport=paramiko on older platforms rather than
# removing it

ssh_args=-o PasswordAuthentication=no -o ControlMaster=auto -o ControlPersist=60s -o ControlPath=/tmp/ansible-ssh-%h-%p-%r

# the following makes ansible use scp if the connection type is ssh (default is sftp)

#scp_if_ssh=True