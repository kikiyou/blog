1. 下载
docker run -p 8080:8080 -p 50000:50000 jenkins

2. 访问 
http://127.0.0.1:8080/


jenkins version
Jenkins 2.46.1


Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

0016cae29829465c99a4f90dc727a520

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

1. 在插件管理中添加仓库
清华大学镜像仓库：
https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json

仓库添加好之后 还要重新获取update

2. 安装pipeline模块

构建步骤
scm	build	existence	regression	report	deploy




-----jenkins 目录结构
root ➜  ~ rpm -ql jenkins
/etc/init.d/jenkins
/etc/logrotate.d/jenkins
/etc/sysconfig/jenkins
/usr/lib/jenkins
/usr/lib/jenkins/jenkins.war
/usr/sbin/rcjenkins
/var/cache/jenkins
/var/lib/jenkins
/var/log/jenkins


----docker 团队
https://jenkins.dockerproject.org/



问题：
1.
groovy的脚本 可以在http://<jenkins>:8080/script 执行
写到pipeline中，调用系统有些库，会报错 不允许。

原因：在pipeline中,为了安全性groovy默认是在一个sandbox环境中运行的

解决办法：
1. Jenkins -> 系统管理 -> In-process Script Approval 当在sanbox环境中被拒绝调用的api会显示在这里，点击Approval 允许即可  （ps：这里很反人类，允许只能一个个的允许，点一堆很痛苦）
2. 在新建的pipeline任务中，下面有个默认勾选的选项，去除勾选，让任务不在sandbox中允许即可。


引入外部sdk
1. Go to Jenkins > Manage Jenkins > Configure System
2. Check "Environment variables"
3. add name: ANDROID_HOME, value -> your android sdk dir
4. click "add"
5. SCROLL DOWN CLICK SAVE


-----远程执行脚本
(fonsview_deploy) monkey ➜  groovy cat run.sh 
script_path=$1
echo $script_path
mytoken=$(curl --user 'monkey:123.coM' -s http://127.0.0.1:8080/crumbIssuer/api/json | python -c 'import sys,json;j=json.load(sys.stdin);print j["crumbRequestField"] + "=" + j["crumb"]')
curl --user 'monkey:123.coM' -d "$mytoken" --data-urlencode "script=$(<$script_path)" http://127.0.0.1:8080/scriptText
---
run.sh 1.groovy

http://myserver/jenkins/scriptler/run/<yourScriptId>?param1=value1

## jenksins 启用ssh server
install sshd 模块
jenkins -> 系统管理 -> 系统设置 --> SSH Server --> SSHD Port	--> 随机一个port

## 启动docker镜像端口
安装Docker plugin 模块
 tcp://172.16.42.43:4243 or unix:///var/run/docker.sock


CloudBees Docker Build and Publish1.3.2  利用dockerfile 构建系统

好网站教你怎么打包镜像
https://www.katacoda.com/