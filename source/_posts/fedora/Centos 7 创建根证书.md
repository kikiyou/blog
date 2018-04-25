## CA 服务器创建过程
+ 创建根私有证书： rootCA.key
openssl genrsa -out rootCA.key 2048

+ 创建根公共证书：rootCA.pem
openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem


Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:sxpi
Locality Name (eg, city) [Default City]:sxpi 
Organization Name (eg, company) [Default Company Ltd]:sxpi
Organizational Unit Name (eg, section) []:sxpi
Common Name (eg, your name or your server's hostname) []:sxpi CA
Email Address []:admin@sxpi.com


## web服务证书创建过程

+ 创建私有证书：apache.key
openssl genrsa -out apache.key 2048

+ 根据私有证书，创建证书请求文件：apache.csr

openssl req -new -key apache.key -out apache.csr
注： 这里受信任域名，是你网站要访问的域名
Common Name (eg, your name or your server's hostname)
一定不能乱写，别的随意。

Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:sxpi
Locality Name (eg, city) [Default City]:sxpi
Organization Name (eg, company) [Default Company Ltd]:sxpi
Organizational Unit Name (eg, section) []:sxpi
Common Name (eg, your name or your server's hostname) []:sxpi.com
Email Address []:admin@sxpi.com
注：下面输入回车
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

## CA 服务器,根据证书请求文件apache.csr签发，信任sxpi.com这个域名的证书,下发证书apache.crt

openssl x509 -req -in apache.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out apache.crt -days 500 -sha256


根据上面操作你已经生成下面证书：
total 24
-rw------- 1 root root 1253 Apr 17 12:08 apache.crt
-rw------- 1 root root 1029 Apr 17 12:04 apache.csr
-rw------- 1 root root 1675 Apr 17 12:01 apache.key
-rw------- 1 root root 1679 Apr 17 11:54 rootCA.key
-rw------- 1 root root 1371 Apr 17 11:58 rootCA.pem
-rw------- 1 root root   17 Apr 17 12:08 rootCA.srl

## web 服务器配置使用https
mkdir /etc/ssl/private
chmod 700 /etc/ssl/private

cp apache.key /etc/ssl/private/
cp apache.crt /etc/ssl/certs/

## 设置证书
vi /etc/httpd/conf.d/ssl.conf

<VirtualHost _default_:443>
. . .
DocumentRoot "/var/www/html"
ServerName sxpi.com:443


注释下面：
#SSLProtocol all -SSLv2
#SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5:!SEED:!IDEA

添加下面：
SSLCertificateFile /etc/ssl/certs/apache.crt
SSLCertificateKeyFile /etc/ssl/private/apache.key


+ 设定http 请求跳转为https （考试可以不做）
vi /etc/httpd/conf.d/non-ssl.conf

<VirtualHost *:80>
        ServerName sxpi.com
        Redirect "/" "https://sxpi.com/"
</VirtualHost>


+ 配置测试
apachectl configtest

+ 配置重启

systemctl restart httpd.service

+  添加防火墙允许
firewall-cmd --add-service=http
firewall-cmd --add-service=https
firewall-cmd --runtime-to-permanent



客户端测试：
比如： 
apache server ip 是172.16.12.41

1. linux 客户端
vi /etc/hosts
172.16.12.41 sxpi.com


2. windows 客户端
修改：
c:\Windows\System32\Drivers\etc\hosts


客户端使用浏览器访问：
https://sxpi.com/


用户导入根公共证书：
rootCA.pem


如下是截图：
未导入根公共证书：


导入根公共证书之后：