# docker 使用

+ 运行一个docker
docker search redis

docker run -d redis

加tags 放后台运行
docker run -d redis:3.2

+ 发现运行中的docker
docker ps  查看哪些镜像 在后台运行

docker inspect redis   更详细,redis信息列出

docker logs <friendly-name|container-id>  列出docker中标准输入，输出的内容

+ 访问docker里面的内容

-p <host-port>:<container-port>
固定端口绑定：
docker run -d --name redisHostPort -p 6379:6379 redis:latest
默认侦听0.0.0.0  可以设置，-p 127.0.0.1:6379:6379

随机端口绑定：
docker run -d --name redisDynamic -p 6379 redis:latest
获取随机端口：
docker port redisDynamic 6379
可以使用name来发现端口


docker ps
可以列出 docker信息

+ 数据持久化

容器默认设置是没有状态的，绑定目录或卷，进行持久化
 -v <host-dir>:<container-dir>
查文档得知容器里面的存储路径是/data，现在把主机/opt/docker/data/redis进行映射
docker run -d --name redisMapped -v /opt/docker/data/redis:/data redis

docker允许你使用$PWD 作为占位符，表示你当前的目录

+ 在容器中执行命令
docker exec -it <friendly-name|container-id> ps

启用一个交互式的shell
docker exec -it <friendly-name|container-id> bash

## 创建和构建一个新的镜像
1. 创建一个dockerfile
Dockerfile

FROM nginx:alpine
COPY . /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80

-----
EXPOSE 命令表示内部侦听的端口


2. 构建一个镜像
echo "hello 123" > index.html

docker build -t webserver-image:v1 .

3. 运行
docker run -d -p 80:80 webserver-image:v1

访问：
127.0.0.1

4. dockerfile介绍
（1）
Dockerfile只允许使用一次CMD指令。 使用多个CMD会抵消之前所有的指令，只有最后一个指令生效。
CMD有三种形式：
CMD ["cmd", "-a", "arga value", "-b", "argb-value"],
CMD ["param1","param2"]
CMD command param1 param2

（2） 构建
docker build  默认从Dockerfile构建

docker build  -t <name>  从指定名字构建

（3） 列出本地已有镜像
docker images

##
FROM node:7-alpine

RUN mkdir -p /src/app

WORKDIR /src/app


## 附加环境变量
docker run -d --name my-production-running-app -e NODE_ENV=production -p 3000:3000 my-nodejs-app



## 构建nodejs的docker file
FROM node:7
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install
ONBUILD COPY . /usr/src/app
CMD [ "npm", "start" ]


（4） 忽略文件
echo passwords.txt >> .dockerignore

把不用的文件 写到.dockerignore 可以提升构建速度


## 数据容器
docker create -v /config --name dataContainer busybox
echo "#config" > config.conf
docker cp config.conf dataContainer:/config


把卷附加到ubuntu这个镜像下面
docker run --volumes-from dataContainer ubuntu ls /config

查看卷中的内容
docker run --volumes-from dataContainer ubuntu cat /config/config.conf


导入和导出容器：
导出：
docker export dataContainer > dataContainer.tar
导入：
docker import dataContainer.tar

## export import save load的区别

export 是不能回滚以前的操作的
save 是完整的导出，可以和以前的镜像那样，可以回滚操作
save 保存所有数据
export 导出当前状态

##容器连接(容器自己内部通信)
--link name:alias
--link 父亲名字:父亲别名 子容器
docker run --link redis-server:redis alpine env
docker run --link redis-server:redis alpine cat /etc/hosts
docker run --link redis-server:redis alpine ping -c 1 redis

示例：
docker run -d -p 3000:3000 --link redis-server:redis katacoda/redis-node-docker-example

子容器：katacoda/redis-node-docker-example 作为redis的客户端
父亲容器：redis-server 是redis的server 使用--link 创建的别名是 redis 连接起来

子容器和父容器连接，并把子容器的对外端口暴露出来


## 使用自己的redis-cli连接自己
docker run -it --link redis-server:redis redis redis-cli -h redis
和
docker run -it redis-server  redis-cli
效果一样 

## 列出的容器
docker ps 列出正在运行的容器
docker ps -a   列出所有容器



##docker 容器网络管理
+ 从自己定义的名字 创建后端网络
docker network create backend-network
列出已经创建的网络
docker  network ls

+ 使用 --net 属性 指定我们要连接到哪个网络
docker run -d --name=redis --net=backend-network redis

+ 和使用--link有区分 ，不像link是修改 env和hosts
root ➜  docker_work docker run --net=backend-network alpine env
root ➜  docker_work docker run --net=backend-network alpine cat /etc/hosts

通过下面几个命令可知，容器是通告集成的dns来通信的 dns服务器地址127.0.0.11 
docker run --net=backend-network alpine cat /etc/resolv.conf
docker run --net=backend-network redis cat /etc/resolv.conf
docker run --net=backend-network alpine ping -c1 redis


+ 通过自己创建的network来通信
docker network create frontend-network    创建网络
docker network connect frontend-network redis   把redis加到网络
docker run -d -p 3000:3000 --net=frontend-network katacoda/redis-node-docker-example  把nodejs的加到网络

通告上面构建，使用下面命令可以查看到，node和redis通信正常
curl  127.0.0.1:3000

+ 创建别名
就像使用--link 会在hosts中创建对应关系一样，使用--alias 可以扩展 内部dns，添加一条记录，方便查找
docker network create frontend-network2
docker network connect --alias db frontend-network2 redis
docker run --net=frontend-network2 alpine ping -c1 db

+ 断开网络连接
docker network ls
docker network inspect frontend-network
docker network disconnect frontend-network redis

## 使用数据卷持久化数据
docker run  -v /docker/redis-data:/data \
  --name r1 -d redis \
  redis-server --appendonly yes

cat data | docker exec -i r1 redis-cli --pipe
ls /docker/redis-data


把目录挂载到ubuntu下面的 /backup中
docker run  -v /docker/redis-data:/backup ubuntu ls /backup

扫描自动把r1的挂载目录 maping到ubuntu上
docker run --volumes-from r1 -it ubuntu ls /data

+ 只读卷
默认挂载的卷是读写的，可以使用这个方式改为只读的
docker run -v /docker/redis-data:/data:ro -it ubuntu rm -rf /data

## 管理日志文件
容器的日志支持多种方式，可以通过配置--log-driver=VALUE来选择不同的驱动方式，包含none, json-file,syslog,journald,gelf,fluentd,awslogs,splunk,etwlogs,gcplogs
+启用syslog  用下面的命令把 log定向给syslog
docker run -d --name redis-syslog --log-driver=syslog redis
+关闭syslog
docker run -d --name redis-none --log-driver=none redis



查看log的设置
root ➜  docker_work docker inspect --format '{{ .HostConfig.LogConfig }}' redis-server
{json-file map[]}
root ➜  docker_work docker inspect --format '{{ .HostConfig.LogConfig }}' redis-syslog
{syslog map[]}
root ➜  docker_work docker inspect --format '{{ .HostConfig.LogConfig }}' redis-none
{none map[]}

## 容器的停止处理
默认情况下容器会把返回值非0的 认为是崩溃的，崩溃的容器状态会为stopped
可以使用docker ps -a 查看到

使用下面命令可以看到输出
docker logs restart-default

+ 容器的停止后重试
--restart=on-failure: 参数可以让你指定，失败后重试多少次
docker run -d --name restart-3 --restart=on-failure:3 scrapbook/docker-restart-example

+ 总是重启
当失败之后，总是尝试重启。
docker run -d --name restart-always --restart=always scrapbook/docker-restart-example

## 容器 标签
-l 指定标签
docker run -l user=12345 -d redis

+ 从外部文件读取标签
echo 'user=123461' >> labels && echo 'role=cache' >> labels

--label-file=<filename> 选项，把文件中每行读取
docker run --label-file=labels -d redis

+ 查询 标签
查询 容器
docker ps --filter "label=user=scrapbook"

查询 镜像
docker images --filter "label=vendor=Katacoda"

Daemon labels
docker -d \
-H unix:///var/run/docker.sock \
--label com.katacoda.environment="production" \
--label com.katacoda.storage="ssd"
