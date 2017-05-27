## harbor 仓库安装

1. 下载离线包
2. 解压
3. 编辑 harbor.cfg

默认端口：80
默认用户名  密码
admin/Harbor12345

## 安装
./install.sh

## 配置 使用代理缓存镜像 （ps: 使用后无法push镜像，会报错"Upload failed, retrying: unsupported"）
配置镜像缓存，客户端先访问harbor，如果harbor没有 会去阿里云下载，并缓存到本地harbor
以后客户端下载，可直接使用本地harbor的

1. vi common/templates/registry/config.yml
proxy:
  remoteurl: https://fcpj2tcn.mirror.aliyuncs.com

2. 重启服务
docker-compose down
docker-compose rm -f
docker-compose up -d


##客户端使用harbor
root ➜  workspace cat /etc/docker/daemon.json 
{
  "registry-mirrors": ["http://monkey.rhel.cc"],
  "insecure-registries": ["monkey.rhel.cc"]
}

systemctl  restart docker

重启后 使用docker info
看到如下内容，说明配置成功
Insecure Registries:
 monkey.rhel.cc
 127.0.0.0/8
Registry Mirrors:
 http://monkey.rhel.cc

登录: 
docker login -u admin -p Harbor12345 monkey.rhel.cc
下载：
docker pull

上传：
docker tag centos7.1:tomcat monkey.rhel.cc/library/centos7.1:tomcat
docker push monkey.rhel.cc/library/mongodb

本地docker日志查看：
journalctl  -f _SYSTEMD_UNIT=docker.service


[参考](https://github.com/vmware/harbor/blob/master/contrib/Configure_mirror.md)