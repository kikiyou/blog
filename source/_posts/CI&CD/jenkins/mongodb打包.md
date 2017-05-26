## 使用jenkins构建 mongodb

1. 安装插件 Docker plugin 和 Git plugin
Jenkins -> 系统管理 -> 管理插件 -> 可选插件 在里面搜索Docker plugin 和 Git plugin安装之。

2. 配置Docker plugin
Jenkins -> 系统管理 --> 云-> 新增一个云 Docker
Name：docker-agent
Docker URL：unix:///var/run/docker.sock

1. 开放权限
sudo chmod 777 /var/run/docker.sock
2. 点击 Test Connection 测连接

3. 配置镜像
在 Jenkins -> 系统管理 --> 云-> 新增一个云 Docker 中
+ 下拉 选择Add Docker Template
Docker Image： library/centos7.1-v1
Credentials:  使用add添加 并选择
用户名：jenkins 密码：jenkins
Volumes	--》 /var/run/docker.sock:/var/run/docker.sock

+ 配置


4. 创建一个job
