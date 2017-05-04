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

+ 辅助函数 
辅助函数位于 system/helpers 或者 application/helpers 目录 目录下。

+ CodeIgniter 类库
所有的系统类库都位于 system/libraries/ 目录下

+ 使用 CodeIgniter 驱动器

+ 以下是系统核心文件的清单，它们在每次 CodeIgniter 启动时被调用：

Benchmark
Config
Controller
Exceptions
Hooks
Input
Language
Loader
Log
Output
Router
Security
URI
Utf8

+ 扩展类
扩展核心类
如果你只是想往现有类中添加一些功能，例如增加一两个方法，这时替换整个类感觉就有点杀鸡用牛刀了。在这种情况下，最好是使用扩展类的方法。扩展一个类和替换一个类的做法几乎是一样的，除了要注意以下几点：

你定义的类必须继承自父类。
你的类名和文件名必须以 MY_ 开头。（这是可配置的，见下文）
举个例子，要扩展原始的 Input 类，你需要新建一个文件 application/core/MY_Input.php，然后像下面这样定义你的类:

class MY_Input extends CI_Input {

}

+ 应用程序流程图

下图说明了整个系统的数据流程：

![图](http://codeigniter.org.cn/user_guide/_images/appflowchart.png)


CodeIgniter 程序流程

index.php 文件作为前端控制器，初始化运行 CodeIgniter 所需的基本资源；
Router 检查 HTTP 请求，以确定如何处理该请求；
如果存在缓存文件，将直接输出到浏览器，不用走下面正常的系统流程；
在加载应用程序控制器之前，对 HTTP 请求以及任何用户提交的数据进行安全检查；
控制器加载模型、核心类库、辅助函数以及其他所有处理请求所需的资源；
最后一步，渲染视图并发送至浏览器，如果开启了缓存，视图被会先缓存起来用于 后续的请求。

+ 挂钩点

以下是所有可用挂钩点的一份列表：

pre_system 在系统执行的早期调用，这个时候只有 基准测试类 和 钩子类 被加载了， 还没有执行到路由或其他的流程。
pre_controller 在你的控制器调用之前执行，所有的基础类都已加载，路由和安全检查也已经完成。
post_controller_constructor 在你的控制器实例化之后立即执行，控制器的任何方法都还尚未调用。
post_controller 在你的控制器完全运行结束时执行。
display_override 覆盖 _display() 方法，该方法用于在系统执行结束时向浏览器发送最终的页面结果。 这可以让你有自己的显示页面的方法。注意你可能需要使用 $this->CI =& get_instance() 方法来获取 CI 超级对象，以及使用 $this->CI->output->get_output() 方法来 获取最终的显示数据。
cache_override 使用你自己的方法来替代 输出类 中的 _display_cache() 方法，这让你有自己的缓存显示机制。
post_system 在最终的页面发送到浏览器之后、在系统的最后期被调用。

+ URI 路由
一般情况下，一个 URL 字符串和它对应的控制器中类和方法是一一对应的关系。 URL 中的每一段通常遵循下面的规则:

example.com/class/function/id/

+ 首页第一个索引在

application/controllers/Welcome.php