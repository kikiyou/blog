#!/usr/bin/env python
#-*- coding:utf8 -*-
# sources
# 1. https://gist.github.com/tell-k/4943359#file-paramiko_proxycommand_sample-py-L11
# 2. https://github.com/paramiko/paramiko/pull/97
# info: http://bitprophet.org/blog/2012/11/05/gateway-solutions/
#  local -> proxy-server -> dest-server
# ~/.ssh/config
#
#  Host proxy-server
#     User hoge
#     HostName proxy.example.com
#     IdentityFile ~/.ssh/id_rsa_proxy
#
#  Host dest-server
#     User fuga
#     HostName proxy.example.com
#     IdentityFile ~/.ssh/id_rsa_dest
#     ProxyCommand ssh proxy-server nc %h %p
#
import os
import sys
import paramiko
from v5_token import DawxOpenApi 

def test_client(host_name):
    conf = paramiko.SSHConfig()
    conf.parse(open(os.path.expanduser('~/.ssh/config')))
    print conf
    host = conf.lookup(host_name)
    print host
    client = paramiko.SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    
    ainstanse = DawxOpenApi()

    toeken = ainstanse.do_request()
    QQ_PASSWD = "dawx@99!"
    password = QQ_PASSWD + toeken

    client.connect(
        host['hostname'], username='user',
        # if you have a key file 
        # key_filename=host['identityfile'], 
        password=password,
        sock=paramiko.ProxyCommand(host.get('proxycommand'))
    )
    stdin, stdout, stderr = client.exec_command('whoami')
    print stdout.read()

if __name__ == '__main__':
    test_client(sys.argv[1])