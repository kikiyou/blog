# 本教程是针对apache 的自签名证书的使用

## 组件安装

+ 安装apache服务

yum install httpd

设置apache开机自启动
systemctl enable httpd.service

+ 安装Mod SSL

yum install mod_ssl

## 创建新的证书

+ 
mkdir /etc/ssl/private
chmod 700 /etc/ssl/private

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

输入如下信息：
Country Name (2 letter code) [XX]:CN
State or Province Name (full name) []:Example
Locality Name (eg, city) [Default City]:Example
Organization Name (eg, company) [Default Company Ltd]:Example Inc
Organizational Unit Name (eg, section) []:Example Dept
Common Name (eg, your name or your server's hostname) []:example.com
Email Address []:admin@example.com


输入下面命令后，要等待几分钟，请耐心等待。
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

cat /etc/ssl/certs/dhparam.pem | sudo tee -a /etc/ssl/certs/apache-selfsigned.crt

## 设置证书
vi /etc/httpd/conf.d/ssl.conf

<VirtualHost _default_:443>
. . .
DocumentRoot "/var/www/html"
ServerName example.com:443


注释下面：
#SSLProtocol all -SSLv2
#SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5:!SEED:!IDEA

添加下面：
SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key


+ 设定http 请求跳转为https （比赛时可以不做）
vi /etc/httpd/conf.d/non-ssl.conf

<VirtualHost *:80>
        ServerName example.com
        Redirect "/" "https://example.com/"
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
172.16.12.41 example.com


2. windows 客户端
修改：
c:\Windows\System32\Drivers\etc\hosts


客户端使用浏览器访问：
https://example.com/
