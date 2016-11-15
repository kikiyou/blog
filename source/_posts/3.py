import paramiko
import socket
import logging
from v5_token import DawxOpenApi 

logging.basicConfig(loglevel=logging.DEBUG)
LOG = logging.getLogger("xxx")

def http_proxy_tunnel_connect(proxy, target,timeout=None):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        sock.connect(proxy)
        LOG.debug("connected")
        cmd_connect = "CONNECT %s:%d HTTP/1.1\r\n\r\n"%target
        LOG.debug("--> %s"%repr(cmd_connect))
        sock.sendall(cmd_connect)
        response = []
        sock.settimeout(10) # quick hack - replace this with something better performing.
        try: 
            # in worst case this loop will take 2 seconds if not response was received (sock.timeout)
            while True:
                chunk = sock.recv(1024)
                if not chunk: # if something goes wrong
                    break
                response.append(chunk)
                if "\r\n\r\n" in chunk: # we do not want to read too far ;)
                    break
        except socket.error, se:
            if "timed out" not in se:
                response=[se]
        response = ''.join(response)
        print response
        LOG.debug("<-- 444%s"%repr(response))
        if not "200 connection established" in response.lower():
            raise Exception("Unable to establish HTTP-Tunnel: %s"%repr(response))
        return sock

if __name__=="__main__":
    ainstanse = DawxOpenApi()
    toeken = ainstanse.do_request()
    print toeken
    QQ_PASSWD = "dawx@99!"
    password =  toeken + QQ_PASSWD
    print password
    LOG.setLevel(logging.DEBUG)
    LOG.debug("--start--")
    sock = http_proxy_tunnel_connect(proxy=("183.60.118.143",80), 
                                     target=("10.204.174.31",36000),
                                     timeout=50)
    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname="10.204.174.31",sock=sock, username="app100688853", password=password)
    print "#> whoami \n%s"% ssh.exec_command("whoami")[1].read()