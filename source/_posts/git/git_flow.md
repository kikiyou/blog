# git flow 工作流的使用

## 安装gitflow
sudo dnf install gitflow

## 把已有仓库 初始化为 gitflow仓库
$ cd project_dir
$ git flow init
$ git branch 
* develop
  master

## 创建 Feature
$ git flow feature start authentication
$ git flow feature finish authentication

## Versioned releases 
$ git flow release start 0.1.0

$ git flow release finish 0.1.0

## Hotfixing production code
$ git flow hotfix start assets
$ git flow hotfix finish assets
