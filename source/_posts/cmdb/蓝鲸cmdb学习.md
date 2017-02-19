蓝鲸配置平台go语言版：

https://github.com/shwinpiocess/cc

蓝鲸有97个文件 变更，学习这97个文件就ok

1. 根据环境变量 读配置
development
testing
production


system_path => system
application_folder => application
view_folder => ''  默认view路径在application目录下面

define('BASEPATH', str_replace('\\', '/', $system_path));
 把\\ 替换成 /



在index 文件中定义了

BASEPATH   -->对应的system目录
FCPATH
SYSDIR
APPPATH
VIEWPATH 
的路径



使用了CodeIgniter 框架

使用查询字符串的url方式，把FALSE 改为true
$config['enable_query_strings'] = FALSE;

样子如下：
index.php?c=controller&m=method


url 分段传递参数：
example.com/index.php/products/shoes/sandals/123

会在contrl 目录下找products文件  shoes 类中 接收 sandals 和 123 两个参数

+ 默认控制器
在 application/config/routes.php 中定义了默认控制器 welcome

$route['default_controller'] = 'welcome';  访问网站首页时跳转到这里