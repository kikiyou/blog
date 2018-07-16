团队协作，为了规范，一般都是fork组织的仓库到自己帐号下，再提交pr，组织的仓库一直保持更新，下面介绍如何保持自己fork之后的仓库与上游仓库同步。

下面以我 fork 团队的博客仓库为例

点击 fork 组织仓库到自己帐号下，然后就可以在自己的帐号下 clone 相应的仓库

使用 git remote -v 查看当前的远程仓库地址，输出如下：

origin  git@github.com:ibrother/staticblog.github.io.git (fetch)
origin  git@github.com:ibrother/staticblog.github.io.git (push)
可以看到从自己帐号 clone 下来的仓库，远程仓库地址是与自己的远程仓库绑定的（这不是废话吗）

接下来运行 git remote add upstream https://github.com/grafana/grafana.git

这条命令就算添加一个别名为 upstream（上游）的地址，指向之前 fork 的原仓库地址。git remote -v 输出如下：

origin  git@github.com:ibrother/staticblog.github.io.git (fetch)
origin  git@github.com:ibrother/staticblog.github.io.git (push)
upstream        https://github.com/grafana/grafana.git (fetch)
upstream        https://github.com/grafana/grafana.git (push)
之后运行下面几条命令，就可以保持本地仓库和上游仓库同步了

git fetch upstream
git checkout master
git merge upstream/master
接着就是熟悉的推送本地仓库到远程仓库

git push origin master


-------------------------
git fetch upstream
git checkout fsv
git merge upstream/master

go run build.go -buildNumber=1  build-server
go run build.go -buildNumber=1 package latest
-----------------------

获取远程的tags
git fetch upstream
git fetch --tags upstream
git merge v5.2.1