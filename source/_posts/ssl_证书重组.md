---
title: ssl 证书更换过程
date: 2016-11-3 11:31:44
tags: 
- linux
- webserver
---
# 今天我们网站的ssl 证书过期了，更换过程如下

## 从Go Daddy 获取的ssl证书  格式如下
``` bash
cb94a56b13a8c573.crt
gd_bundle-g2-g1.crt

lighttp配置证书如下：
$SERVER["socket"] == ":443" {
     ssl.engine = "enable"
     ssl.pemfile = "/etc/lighttpd/ssl/fbtw.pem"
     ssl.ca-file = "/etc/lighttpd/ssl/gd_bundle.crt"
}
``` 
 

## 证书重组过程如下

1. cp  gd_bundle-g2-g1.crt    gd_bundle.crt

2. vi fbtw.pem 

``` bash
-----BEGIN CERTIFICATE-----
XXXX
-----END CERTIFICATE-----
 

把中间XXX,替换为 cb94a56b13a8c573.crt 中的内容
```



*** 注：fbtw.pem  中包含 ***
``` bash
-----BEGIN PRIVATE KEY-----
XXXX
-----END PRIVATE KEY-----
-----BEGIN CERTIFICATE-----
XXXXX
-----END CERTIFICATE-----
```
这样的格式，只需要替换 BEGIN CERTIFICATE 到END CERTIFICATE 之间内容即可
