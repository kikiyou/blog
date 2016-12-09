http://www.jianshu.com/p/7a0d6917e009


https://www.gitlab.cc/downloads/


gitlab地址：
https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-8.14.1-ce.1.el7.x86_64.rpm

安装:
$ rpm -ivh gitlab-ce-8.14.1-ce.1.el7.x86_64.rpm

## 初始化 GitLab
sudo gitlab-ctl reconfigure

## 修改host

添加访问的 host，修改/etc/gitlab/gitlab.rb的external_url

external_url 'http://git.home.com'

vi /etc/hosts，添加 host 映射
127.0.0.1 git.home.com

每次修改/etc/gitlab/gitlab.rb，都要运行以下命令，让配置生效

sudo gitlab-ctl reconfigure
配置本机的 host，如：192.168.113.59 git.home.com。最后，在浏览器打开网址http://git.home.com，登陆。默认管理员：

用户名: root
密码: 5iveL!fe


下载汉化包后上传服务器后解压。下载链接

停止Gitlab服务。

sudo gitlab-ctl stop

备份服务器上的/opt/gitlab/embedded/service/gitlab-rails目录。 注：该目录下的内容主要是web应用部分，也是当前项目仓库的起始版本，也是汉化包要覆盖的目录。

将解压后的汉化包覆盖服务器上的/opt/gitlab/embedded/service/gitlab-rails目录。

启动Gitlab服务。

sudo gitlab-ctl start

重新执行配置命令。

sudo gitlab-ctl reconfigure

完成上述步骤即实现汉化。
