# jenkins 使用groovy创建用户

1. 创建文件$JENKINS_HOME/init.groovy.d/basic-security.groovy
   在fedoar系统中jenkisn的家目录是/var/lib/jenkins

2. 把下面代码粘贴到basic-security.groovy创建的用户admin_name 密码admin_password
#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)

hudsonRealm.createAccount("admin_name","admin_password")
instance.setSecurityRealm(hudsonRealm)
instance.save()

3. 重启 jenkins服务
systemctl restart jenkins

4. 删除basic-security.groovy 文件
rm /var/lib/jenkins/init.groovy.d/basic-security.groovy

5. localhost:8080 登录主机