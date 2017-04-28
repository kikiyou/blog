# linux 使用juniper ssl vpn

1. 下载ncLinuxApp.jar 软件包

在浏览器输入https://xxxxxx/dana-cached/nc/ncLinuxApp.jar下载这个jar文件（xxxxx是你公司的vpn地址）

2. 创建目录 并解压相关软件包

$ mkdir -p ~/.juniper_networks/network_connect/
$ unzip ncLinuxApp.jar -d ~/.juniper_networks/network_connect/
$ sudo chown root:root ~/.juniper_networks/network_connect/ncsvc
$ sudo chmod 6711 ~/.juniper_networks/network_connect/ncsvc
$ chmod 744 ~/.juniper_networks/network_connect/ncdiag


3. 下载jnc软件包，复制到 /usr/local/bin目录下面 并且赋予执行权限

wget http://www.scc.kit.edu/scc/net/juniper-vpn/linux/jnc -o /usr/local/bin/jnc

chmo +x /usr/local/bin/jnc

4. 安装32位兼容软件包
On centos 6/7 and higher:
# yum install glibc.i686 zlib.i686 nss.i686

5. 获取认证密钥
cd ~/.juniper_networks/network_connect/
sh getx509certificate.sh sslvpn.XXXXX.com 509.pem

6. 创建配置文件
mkdir -p ~/.juniper_networks/network_connect/config
vi ~/.juniper_networks/network_connect/config/somename.conf
host=sslvpn.XXXXX.com
user=xxxx
password=xxxx
realm=FiberHome-realm
cafile=/root/.juniper_networks/network_connect/509.pem


注意：realm  每个公司不一样的，请访问sslvpn.XXXXX.com 查看网页源码
<input type="hidden" name="realm" value="FiberHome-realm"> 
其中value 为realm的值

7. 启动/关闭 
$ jnc --nox somename

$ jnc stop

For more options see

$ jnc --help 


启动成功空 可以ping 一下
10.19.8.10

8. 排错
ncsvc这32位程序 经常会有问题，请使用如下方法检测

[root@fonsview network_connect]# ldd ncsvc
	linux-gate.so.1 =>  (0xf77b7000)
	libdl.so.2 => /lib/libdl.so.2 (0xf778d000)
	libz.so.1 => /lib/libz.so.1 (0xf7776000)
	libpthread.so.0 => /lib/libpthread.so.0 (0xf775b000)
	libm.so.6 => /lib/libm.so.6 (0xf7718000)
	libc.so.6 => /lib/libc.so.6 (0xf7559000)
	/lib/ld-linux.so.2 (0xf77b8000)
