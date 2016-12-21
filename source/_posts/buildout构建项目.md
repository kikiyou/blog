Buildout

用Buildout来构建Python项目
Tuesday, March 12, 2013
什么是Buildout
alt Buildout
(Remixed by Matt Hamilton, original from http://xkcd.com/303)

Buildout是一个基于Python的构建工具, 通过一个配置文件，可以从多个部分创建、组装并部署你的应用，即使应用包含了非Python的组件，Buildout也能够胜任. Buildout不但能够像setuptools一样自动更新或下载安装依赖包，而且还能够像virtualenv一样，构建一个封闭隔离的开发环境.

初始化Buildout
首先我们新建一个目录来共享Buildout配置和文件:

~/Projects$ mkdir buildout
~/Projects$ cd buildout
下载一个2.0的bootstrap.py脚本:

~/Projects/buildout$ wget http://downloads.buildout.org/2/bootstrap.py
然后创建一个Buildout的配置文件:

~/Projects/buildout$ touch buildout.cfg
运行bootstrap.py来生成Buildout相关的文件和目录:

~/Projects/buildout$ python bootstrap.py
Creating directory '/Users/Eric/Projects/buildout/bin'.
Creating directory '/Users/Eric/Projects/buildout/parts'.
Creating directory '/Users/Eric/Projects/buildout/eggs'.
Creating directory '/Users/Eric/Projects/buildout/develop-eggs'.
Generated script '/Users/Eric/Projects/buildout/bin/buildout'.
从上面可以看出，创建了目录bin，parts，eggs，develop-eggs，在bin目录下生成了buildout脚本:

bin目录用来存放生成的脚本文件
parts目录存放生成的数据，大多用不上
develop-eggs 存放指向开发目录的链接文件。和buildout.cfg中develop选项相关
eggs 是存放从网络上下载下来的egg包。这些包一般在buildout.cfg中的egg选项里定义
把Python和Pyramid集成进来
配置Buildout

~/Projects/buildout$ vim buildout.cfg
[buildout]
# 每个buildout都要有一个parts列表，也可以为空。
# parts用来指定构建什么。如果parts中指定的段中还有parts的话，会递归构建。
parts = tools

[tools]
# 每一段都要指定一个recipe, recipe包含python的代码，用来安装这一段,
# zc.recipe.egg就是把一些把下面的egg安装到eggs目录中
recipe = zc.recipe.egg
# 定义python解释器
interpreter = python
# 需要安装的egg
eggs =
    pyramid
执行buildout命令来构建一下, 这将会把Pyramid集成进来:

~/Projects/buildout$ bin/buildout
用buildout来构建项目
现在可以创建Pyramid应用了:

~/Projects/buildout$ bin/pcreate -t starter myproject
配置一下Buildout:

~/Projects/buildout$ vim buildout.cfg
[buildout]
parts =
    tools
    apps
develop = myproject

[tools]
recipe = zc.recipe.egg
interpreter = python
eggs =
    pyramid

[apps]
recipe = zc.recipe.egg
eggs = myproject
再次运行一下buildout:

~/Projects/buildout$ bin/buildout
现在可以再buildout的环境中启动myproject了:

~/Projects/buildout$ bin/pserve myproject/development.ini
Starting server in PID 40619.
serving on http://0.0.0.0:6543
最佳实践/Tips
1. 固化egg的版本
把所有的版本信息写到[versions]里面:

extends = versions.cfg
versions = versions
show-picked-versions = true

配置中的“show-picked-versions = true “会在运行buildout的时候把所有的版本打印出来, 把它写到"versions.cfg"中就可以固化了:

[versions]
Chameleon = 2.11
Mako = 0.7.3
MarkupSafe = 0.15
PasteDeploy = 1.5.0
WebOb = 1.2.3
distribute = 0.6.35
repoze.lru = 0.6
translationstring = 1.1
venusian = 1.0a7
zc.buildout = 2.0.1
zc.recipe.egg = 2.0.0a3
zope.deprecation = 4.0.2
zope.interface = 4.0.5

# Required by:
# pyramid-debugtoolbar==1.0.4
Pygments = 1.6

# Required by:
# myproject==0.0
pyramid = 1.4

# Required by:
# myproject==0.0
pyramid-debugtoolbar = 1.0.4

# Required by:
# myproject==0.0
waitress = 0.8.2
2. 使用mr.developer插件来组织大型的项目, 让开发更方便
[buildout]
...
extensions = mr.developer
…
3. 开发环境 VS 生产环境
我们可以创建多个配置文件, 比如把buildout.cfg作为生产环境的配置, 把develop的配置从buildout.cfg删除, 创建一个development.cfg作为开发环境的配置:

[buildout]
extends = buildout.cfg
develop = myproject