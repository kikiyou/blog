---
title: php学习
date: 2016-07-14 10:19:44
tags: 
- php
---
#### php学习
<!-- more -->
+ php中显示错误信息 修改php.ini 如下

    1. display_errors = On

    2. error_reporting = E_ALL &~E_NOTICE

    在apache中

    1.php_flag display_errors On

    2.php_alue error_reporting 2039

+ 字符串输出
    1. echo | print
        >echo "string"

        >print "string"

    2. printf
        >printf("my love is %s", 'ljq')

    3. sprinf
        >$str = printf("my love is %s", 'ljq')

        >把字符串赋值给变量，而不是打印输出
+ 类型相关
    1. 获取类型
        string gettype(mixed var)
    2. 转换类型
        boolean settype(mixed var, string type)

+ echo 和 print的区别

    echo 可以输出多个参数

    void echo(string argument1[,....string argumentN])
+ var_dump()
   void var_dump ( mixed $expression [, mixed $... ] )

   显示变量信息，方便debug使用

+ 控制语句
    1. if语句
    ``` php

    if (condition) {
        # code...
    }

    if (condition) echo "";

    if (condition) {
        # code...
    } else {
        # code...
    }

    $retVal = (condition) ? a : b ;
    ```
    2.switch 语句
    ```
    switch (variable) {
        case 'value':
            # code...
            break;

        default:
            # code...
            break;
    }
    ```
    3.循环语句
    ``` php
    while ($a <= 10) {
        # code...
    }

    do {
        # code...
    } while ($a <= 10);

    for ($i=0; $i < ; $i++) {
        # code...
    }
    ```
    4.foreach语句

    ``` php

    $links = array("a.cn","b.cn","c.cn")
    foreach ($links as $link) {
        echo $link,'</br>';
    }

    $links = array('百度' => 'baidu.com' ,'谷歌' => 'google.com',
    '搜狗' => 'sougou.com');

    foreach ($links as $title => $link) {
        echo $title, $link;
    }
    ```
    4.文件包含语句
    ``` php
    include "lib/php/init.inc.php"
    require_once "lib/php/init.inc.php"

    条件include / require
    if (condition) {
        include "lib/php/true.php"
    } else {
        include "lib/php/fail.php"
    }

    只包含一次 include_once /  require_once
    include_once()
    require_once()
    ```

+ 函数 function
    ``` php
    1. 基本函数
    function FunctionName($value='')
    {
        # code...
    }

    2.按引用传递参数
    $cost = 20.99;
    $tax = 0.0575;
    function calculateCost(&$cost, $tax)
    {
        $cost = $cost + ($cost * $tax);
        $tax += 4;
    }
    calculateCost($cost,$tax);
    printf("Tax is %01.2f%%<br />",$tax*100);
    printf("Cost is $%01.2f",$cost);

    3.返回多个值
    function retrieveUserProfile()
    {
        $user[] = "Jason";
        $user[] = "jason@example.com";
        $user[] = "English";
        return $user;
     }

     list($name,$email,$language) = retrieveUserProfile();
     echo "Name:$name, email:$email, language:$language";
     ```
+ 数组
    php中的数组实际上包含了python的字典
    ``` php
    - 创建数组
    1. $state[0] = "Delaware";

    2. 自动创建
       $state[] = "huawin";
       $state[] = "yip";
       $state[] = "tom";

    3. 创建关联数组
        $state['devops'] = 'tom'
        $state['dev'] = 'yip'

    4.使用arrary创建
        （1）索引数组
            $languages = arrary("english","Gaelic","Spanish");
        （2）关联数组
            $languages = array("Spain" => "Spanish","Treland" => "Gaelic");
         (3) php 5.4 起
        $array = ["foo" => "bar","bar" => "foo",];

    5. 使用list() 提取数组
    $users = fopen("users.txt","r");
    while ($line = fgets($users,4096)) {
        list($name, $occupation, $color) = explode("|", $line);
        printf("Name: %s <br />", $name);
        printf("occupation: %s <br />", $occupation);
        printf("Favorite color: %s <br />", $color);
    }
    fclose($users);

    6. print_r() 数组的友好输出

    7. 添加或删除数组
        $states = ["key" => "value","key1" => "value1"]

        (1) 在数组头添加元素
        array_unshift($states,"key","value");

        (2) 在数组尾添加元素
        array_push($states,"key","value");

        (3) 在数组头删除元素
        arrary_shift($states);

        (4) 从数组尾删除元素
        array_pop($states);

    8. 定位数组元素
    $states = ["key" => "value","key1" => "value1"]
        (1) 判断元素是否存在  true|false
            in_array("key",$states)

        (2) 搜索关联数组
            array_key_exists("key",$states)

        (3) 搜索关联数组的值
            array_search("vale",$states)

        (4) 获取数组中所有key
        $keys = array_keys($states);
        print_r($keys)
        OutPut----
        Array([0] => key1 [1] ==> key2)

        (5) 获取数组中的所有value
            values = array_values($states);
            print_r($values)
        OutPut----
        Array([0] => value, [1] => value1)

        (6) 获取当前数组key
        //key()
        while($key = key($states)){
            printf("$s </br",$key);
            next($states)
        }
        OutPut----
        key
        key1

        (7) 获取当前数组的值
        //current()
        while($value = current($states)){
            printf("$s </br",$value);
            next($states)
        }
        OutPut----
        value
        value1

        (8) 获取当前数组的键和值
        //each
        返回当前的键值对，并使指针推进一个位置。
        $current_states =  each($states);
        print_r($current_states)
        OutPut----
         Array([0] => key, [1] => value)

        (9) 移动数组指针到下一个位置
        //next($states)
        $names = ["tom", "yip", "ljq"];
        $name = next($names); //returns "yip"

        (10) 移动指针到前一个位置
        //prev($states)

        (11) 将指针移到第一个位置
        //rest($states)

        (12) 将指针移动到最后一个数组位置
        //end($states)

        (13) 向函数传递数组值
        //arry_walk()

        (14) 确定数组的大小和唯一性
           1. count() /sizeof() 统计大小
           2. array_count_values() 统计出现频率

        (15) 确定唯一的数组元素
        array_unique()

        (16) 数组排序
        1. array_reverse($states)  逆序
        2. sort() 由底到高
        3. natsort 自然排序

        （17）置换数组key和value的值
        array_flip($states)

        （18）合并数组
            new_states = array_merge_recursive($states1, $states2);

+ 面向对象
    1. 构造函数
    function __construct([arg,agr1,agr2.....])

    调用父类的构造函数 
    //parent
    parent::__construct();

    2. 析构函数
    function __destruct()

    3. 静态类型
    self::$visitors++; //赋值

    Visitor::getVisitors(); //引用
    静态字段和方法需要使用self关键字和类名应用
    **声明类属性或方法为静态，就可以不实例化类而直接访问。静态属性不能通过一个类已实例化的对象来访问（但静态方法可以）。**

    4. instanceof关键字
    $manager = new Employee();
    .....
    if ($manager instanceof Emplyee) echo "Yes";
    //判断manager的对象是否为类Employee的实例

    5. 辅助函数
    （1） boolean class_exists(string class_name)
        确定类是否存在

    （2） string get_class(object object)
        确定对象上下文

    （3） array get_class_methods( class_name)
        了解类方法：函数返回一个数组，其中包含class_name类中低昂以的所有方法名

    （4）array get_declared_classes(void) 
        了解类字段:返回关联数组，包含object可用的字段和其值

    （5）string get_parent_class(object)
        确定对象的父类

    （6）boolean interface_exists(string interface_name)
        确定一个接口是否存在
    
    （7）boolean is_a(object object,string class_name)
        确定对象类型
    （8）boolean is_subclass_of(object object, string class_name)
        确定对象的子类类型
    （9）boolean method_exists(object object,string method_name)
        确定方法是否存在

    6.自动加载对象
    old-->
    require_once("class/Books.class.php")
    require_once("class/Employees.class.php")

    new-->
    function __autoload($class){
        require_once("class/$class.class.php")
    }

    自动加载通过定义特殊的__autoload函数，当引用未在脚本中定义的类时，自动调用这个函数。

+ 高级oop特性
    1. 对象克隆
    destinationObject = clone targetObject;
    
    1.1 __clone() 方法
        function __clone(){
            $this->tiecolor = "blue";
        }
        //在执行clone时会自动调用__clone()方法

    2. 继承
    class child_class extends parent_class{
        function new_metchod(){
            print "new_metchod"
        }
    }

    2.1 继承时构造函数的处理
        （1）子类没有构造函数，父类有  会执行父类的
        （2）子类有构造函数  不论父类有没有 都会执行子类的
        （3）如果想执行父类的构造函数 子类的构造函数如下写
            function __construct($name){
                parent::__construct($name);
                echo "<p> child class construct function</p>"
            }
        （4）如果向多个父类的构造函数都要执行，可以使用显式的 引用

    3. 接口 （接口是为了不支持多重继承而设置的，python支持多重继承，所以没有接口）
        接口：声明了所需的函数和常量，但不指定如何实现。
        interf#### php学习
+ php中显示错误信息 修改php.ini 如下

    1. display_errors = On

    2. error_reporting = E_ALL &~E_NOTICE

    在apache中

    1.php_flag display_errors On

    2.php_alue error_reporting 2039

+ 字符串输出
    1. echo | print
        >echo "string"

        >print "string"

    2. printf
        >printf("my love is %s", 'ljq')

    3. sprinf
        >$str = printf("my love is %s", 'ljq')

        >把字符串赋值给变量，而不是打印输出
+ 类型相关
    1. 获取类型
        string gettype(mixed var)
    2. 转换类型
        boolean settype(mixed var, string type)

+ echo 和 print的区别

    echo 可以输出多个参数

    void echo(string argument1[,....string argumentN])
+ var_dump()
   void var_dump ( mixed $expression [, mixed $... ] )

   显示变量信息，方便debug使用

+ 控制语句
    1. if语句
    ``` php

    if (condition) {
        # code...
    }

    if (condition) echo "";

    if (condition) {
        # code...
    } else {
        # code...
    }

    $retVal = (condition) ? a : b ;
    ```
    2.switch 语句
    ```
    switch (variable) {
        case 'value':
            # code...
            break;

        default:
            # code...
            break;
    }
    ```
    3.循环语句
    ``` php
    while ($a <= 10) {
        # code...
    }

    do {
        # code...
    } while ($a <= 10);

    for ($i=0; $i < ; $i++) {
        # code...
    }
    ```
    4.foreach语句

    ``` php

    $links = array("a.cn","b.cn","c.cn")
    foreach ($links as $link) {
        echo $link,'</br>';
    }

    $links = array('百度' => 'baidu.com' ,'谷歌' => 'google.com',
    '搜狗' => 'sougou.com');

    foreach ($links as $title => $link) {
        echo $title, $link;
    }
    ```
    4.文件包含语句
    ``` php
    include "lib/php/init.inc.php"
    require_once "lib/php/init.inc.php"

    条件include / require
    if (condition) {
        include "lib/php/true.php"
    } else {
        include "lib/php/fail.php"
    }

    只包含一次 include_once /  require_once
    include_once()
    require_once()
    ```

+ 函数 function
    ``` php
    1. 基本函数
    function FunctionName($value='')
    {
        # code...
    }

    2.按引用传递参数
    $cost = 20.99;
    $tax = 0.0575;
    function calculateCost(&$cost, $tax)
    {
        $cost = $cost + ($cost * $tax);
        $tax += 4;
    }
    calculateCost($cost,$tax);
    printf("Tax is %01.2f%%<br />",$tax*100);
    printf("Cost is $%01.2f",$cost);

    3.返回多个值
    function retrieveUserProfile()
    {
        $user[] = "Jason";
        $user[] = "jason@example.com";
        $user[] = "English";
        return $user;
     }

     list($name,$email,$language) = retrieveUserProfile();
     echo "Name:$name, email:$email, language:$language";
     ```
+ 数组
    php中的数组实际上包含了python的字典
    ``` php
    - 创建数组
    1. $state[0] = "Delaware";

    2. 自动创建
       $state[] = "huawin";
       $state[] = "yip";
       $state[] = "tom";

    3. 创建关联数组
        $state['devops'] = 'tom'
        $state['dev'] = 'yip'

    4.使用arrary创建
        （1）索引数组
            $languages = arrary("english","Gaelic","Spanish");
        （2）关联数组
            $languages = array("Spain" => "Spanish","Treland" => "Gaelic");
         (3) php 5.4 起
        $array = ["foo" => "bar","bar" => "foo",];

    5. 使用list() 提取数组
    $users = fopen("users.txt","r");
    while ($line = fgets($users,4096)) {
        list($name, $occupation, $color) = explode("|", $line);
        printf("Name: %s <br />", $name);
        printf("occupation: %s <br />", $occupation);
        printf("Favorite color: %s <br />", $color);
    }
    fclose($users);

    6. print_r() 数组的友好输出

    7. 添加或删除数组
        $states = ["key" => "value","key1" => "value1"]

        (1) 在数组头添加元素
        array_unshift($states,"key","value");

        (2) 在数组尾添加元素
        array_push($states,"key","value");

        (3) 在数组头删除元素
        arrary_shift($states);

        (4) 从数组尾删除元素
        array_pop($states);

    8. 定位数组元素
    $states = ["key" => "value","key1" => "value1"]
        (1) 判断元素是否存在  true|false
            in_array("key",$states)

        (2) 搜索关联数组
            array_key_exists("key",$states)

        (3) 搜索关联数组的值
            array_search("vale",$states)

        (4) 获取数组中所有key
        $keys = array_keys($states);
        print_r($keys)
        OutPut----
        Array([0] => key1 [1] ==> key2)

        (5) 获取数组中的所有value
            values = array_values($states);
            print_r($values)
        OutPut----
        Array([0] => value, [1] => value1)

        (6) 获取当前数组key
        //key()
        while($key = key($states)){
            printf("$s </br",$key);
            next($states)
        }
        OutPut----
        key
        key1

        (7) 获取当前数组的值
        //current()
        while($value = current($states)){
            printf("$s </br",$value);
            next($states)
        }
        OutPut----
        value
        value1

        (8) 获取当前数组的键和值
        //each
        返回当前的键值对，并使指针推进一个位置。
        $current_states =  each($states);
        print_r($current_states)
        OutPut----
         Array([0] => key, [1] => value)

        (9) 移动数组指针到下一个位置
        //next($states)
        $names = ["tom", "yip", "ljq"];
        $name = next($names); //returns "yip"

        (10) 移动指针到前一个位置
        //prev($states)

        (11) 将指针移到第一个位置
        //rest($states)

        (12) 将指针移动到最后一个数组位置
        //end($states)

        (13) 向函数传递数组值
        //arry_walk()

        (14) 确定数组的大小和唯一性
           1. count() /sizeof() 统计大小
           2. array_count_values() 统计出现频率

        (15) 确定唯一的数组元素
        array_unique()

        (16) 数组排序
        1. array_reverse($states)  逆序
        2. sort() 由底到高
        3. natsort 自然排序

        （17）置换数组key和value的值
        array_flip($states)

        （18）合并数组
            new_states = array_merge_recursive($states1, $states2);

+ 面向对象
    1. 构造函数
    function __construct([arg,agr1,agr2.....])

    调用父类的构造函数 
    //parent
    parent::__construct();

    2. 析构函数
    function __destruct()

    3. 静态类型
    self::$visitors++; //赋值

    Visitor::getVisitors(); //引用
    静态字段和方法需要使用self关键字和类名应用

    4. instanceof关键字
    $manager = new Employee();
    .....
    if ($manager instanceof Emplyee) echo "Yes";
    //判断manager的对象是否为类Employee的实例

    5. 辅助函数
    （1） boolean class_exists(string class_name)
        确定类是否存在

    （2） string get_class(object object)
        确定对象上下文

    （3） array get_class_methods( class_name)
        了解类方法：函数返回一个数组，其中包含class_name类中低昂以的所有方法名

    （4）array get_declared_classes(void) 
        了解类字段:返回关联数组，包含object可用的字段和其值

    （5）string get_parent_class(object)
        确定对象的父类

    （6）boolean interface_exists(string interface_name)
        确定一个接口是否存在
    
    （7）boolean is_a(object object,string class_name)
        确定对象类型
    （8）boolean is_subclass_of(object object, string class_name)
        确定对象的子类类型
    （9）boolean method_exists(object object,string method_name)
        确定方法是否存在

    6.自动加载对象
    old-->
    require_once("class/Books.class.php")
    require_once("class/Employees.class.php")

    new-->
    function __autoload($class){
        require_once("class/$class.class.php")
    }

    自动加载通过定义特殊的__autoload函数，当引用未在脚本中定义的类时，自动调用这个函数。

+ 高级oop特性
    1. 对象克隆
    destinationObject = clone targetObject;
    
    1.1 __clone() 方法
        function __clone(){
            $this->tiecolor = "blue";
        }
        //在执行clone时会自动调用__clone()方法

    2. 继承
    class child_class extends parent_class{
        function new_metchod(){
            print "new_metchod"
        }
    }

    2.1 继承时构造函数的处理
        （1）子类没有构造函数，父类有  会执行父类的
        （2）子类有构造函数  不论父类有没有 都会执行子类的
        （3）如果想执行父类的构造函数 子类的构造函数如下写
            function __construct($name){
                parent::__construct($name);
                echo "<p> child class construct function</p>"
            }
        （4）如果向多个父类的构造函数都要执行，可以使用显式的 引用

    3. 接口 （接口是为了不支持多重继承而设置的，python支持多重继承，所以没有接口）
        接口：声明了所需的函数和常量，但不指定如何实现。
        interface interface_name{
            function method_name1();
        }
        class Class_Name implements interface_name{
            function method_name1()
            {
                //接口方法的实现
            }
        }

    3.1 实现多个接口
        interface IEmployee {...}
        interface IDeveloper {...}
        interface IPillage {...}

        class Employee implements IEmployee， IDeveloper， iPillage{
            ...
        }

        class Contractor implements IEmployee， IDeveloper{
            ...
        }
    
    4. 抽象类
        抽象类：不能实例化的类，只能作为i由其他类继承的基类。

        abstract class Class_Name
        {
            // insert attribute definition here
            // insert method definition here
        }

    5. 命名空间介绍 （python 不支持 namespace这种写法）
        namespace Foo\Bar\subnamespace;
        namespace Foo\Bar

        使用：
        /* 非限定名称 */        foo(); 
        /* 限定名称 */          subnamespace\foo();
        /* 完全限定名称 */       \Foo\Bar\foo();
        //相当与linux 目录树的概念

    6.异常处理ace interface_name{
            function method_name1();
        }
        class Class_Name implements interface_name{
            function method_name1()
            {
                //接口方法的实现
            }
        }

    3.1 实现多个接口
        interface IEmployee {...}
        interface IDeveloper {...}
        interface IPillage {...}

        class Employee implements IEmployee， IDeveloper， iPillage{
            ...
        }

        class Contractor implements IEmployee， IDeveloper{
            ...
        }
    
    4. 抽象类
        抽象类：不能实例化的类，只能作为i由其他类继承的基类。

        abstract class Class_Name
        {
            // insert attribute definition here
            // insert method definition here
        }

    5. 命名空间介绍 （python 不支持 namespace这种写法）
        namespace Foo\Bar\subnamespace;
        namespace Foo\Bar

        使用：
        /* 非限定名称 */        foo(); 
        /* 限定名称 */          subnamespace\foo();
        /* 完全限定名称 */       \Foo\Bar\foo();
        //相当与linux 目录树的概念

+ 异常处理
    1. 配置指令 
        修改php.ini

    2. 异常处理
        （1）默认构造函数
            throw new Exception();
        
        （2） 重载构造函数
            throw new Exception("Something bad just happened",4);
        
        （3） 方法
            - getMessage() 返回传递给构造函数的消息。
            - getCode() 返回传递给构造函数的错误。
            - getLine() 返回抛出异常的行号。
            - getFile() 返回抛出异常的文件名。
            - getTrace() 返回一个数组,其中包括出现错误的上下文的有关信息。该数组包括 文件名、行号、函数名和函数参数。
            - getTraceAsString() 返回信息同getTrace(),只是返回信息时一个字符串而不是数组。
        
        （4）产生一个异常
            try {
                $fh = fopen("contacts.txt","r");
                if (! $fh) {
                    throw new Exception("Could not open the file!");
                }
            }
            catch (Exception $e){
                echo "Error (File: ".$e->getFile().", line ".$e->getLine()."): ".$e->getMessage();
            }
        
        (5) 扩展异常类
            /**
            * xxx.txt
            * 1,Could not connnect to the database!
            * 2,Incorrect password. Please try again.
            * 3.Username not found.
            */

            class My_Exception extends Exception
            { 
                function __construct($language,$errorcode)
                {
                    $this->language = $language;
                    $this->errorcode = $errorcode;
                }
                public function getMessageMap()
                {
                    $errors = file("errors/".$this->language.".txt");
                    foreach ($errors as $error) {
                        list($key,$value) = explode(",",$error,2);
                        $errorArray[$key] = $value;
                    }
                    return $errorArray[$this->errorcode];
                }
            }

            try{
                throw new My_Exception("english", 4);
            }
            catch (My_Exception $e){
                echo $e->getMessageMap();
            }
            
        (6) 捕获多个异常

+ 字符串和正则表达式
    1. POSIX
        （1） ereg() //搜索

+ 字符处理
    1. ltrim() 从字符开始 裁剪字符。空格等
    2. rtrim() 结束字符开始 裁剪字符。空格等
    3. trim() 从两端 裁剪字符。空格等

+ 处理文件和操作系统
    1. 文件和目录
        $path = "/home/www/data/users.txt"
        （1） string basename($path)      ===> users.txt //获取文件名
        
        （2） string dirname($path)       ===> /home/www/data   //获取目录名
        
        （3） array pathinfo($path)       
        -----
            $pathinfo = pathinfo($path) 
            pathinfo[dirname] ===> /home/www/data
            pathinfo[basename] ===> users.txt
            pathinfo[extension] ===> txt

    2. 计算文件、目录和磁盘大小
        （1） int filesize(string filename)
            //计算指定文件的大小，以字节为单位。

        (2) float disk_free_space(string directory)
            //磁盘可用空间 以字节为单位
            $drive = "/usr"
            disk_free_space($drive)

        (3) float disk_total_space(string directory)
           //计算磁盘总量
           disk_total_space($drive)
        
        (4) 计算目录大小 (标准函数没给,需要自己写) 
    
    3. 确定访问和修改时间
        （1） 确定文件的最后访问时间
        （2） 确定文件的最后改变时间
        （3） 确定文件的最后修改时间

    4. 执行shell命令
        1. 删除目录
            int rmdir(string dirname)
        
        2. 重命名文件
            boolean rename(string oldname, string newname)
        
        3. 创建文件
            int touch(string filename)

    5. 调用系统命令
        1. exec()   //可选返回结果
        2. system()  //直接返回结果
        3. 反引号执行命令
            $result = `date`;
        4. 可代替反引号
            $result = shell_exec("date");

+ PEAR - PHP Extension and Application Repository
    1. Validate_US 
    <?php
        include "Validate/US.php"
        $validate = new Validate_US();
        echo $validate->phoneNumber("614-999-9999") ? "Valid!" ： "Not valid!"
    ?>

    2.使用PEAR包管理器 
    （1）查看以及安装的pear包
        %> pear list
    
    （2）了解信息 
        %> pear info Console_Getopt
    
     (3) 安装
        %>pear install Auth

    (4) 使用
        require_once("Numbers/Roman.php")
+ 表单
    1. 获取表单
        if (isset($_POST['submit']))
        {
            $name = htmlentities($_POST['name']);
        }
    2. 获取多值表单
        if (isset($_POST['submit']))
        {
            foreach($_POST['language' AS $language]){
                $language = htmlentities($language);
                echo "$language<br />";
            }
        }

    3. HTML_QuickForm2
        (1) 安装
            1. wget http://download.pear.php.net/package/HTML_QuickForm2-2.0.2.tgz 
               wget http://download.pear.php.net/package/HTML_Common2-2.1.1.tgz  (QuickForm2的依赖)
            2. 解压后放在  /usr/share/pear/HTML 中或直接引用

            3. 简单帮助 
            （http://pear.php.net/manual/en/package.html.html-quickform2.tutorial.php）
            （https://pear.php.net/manual/en/package.html.html-quickform2.examples.php）

+ 身份验证
    1. 硬编码验证
        <?php
        if (!isset($_SERVER['PHP_AUTH_USER']) || ($_SERVER['PHP_AUTH_PW'] != 'ljq') ) {
            header('WWW-Authenticate: Basic realm="My Realm"');
            header('HTTP/1.0 401 Unauthorized');
            echo 'Text to send if user hits Cancel button';
            exit;
        } else {
            echo "<p>Hello {$_SERVER['PHP_AUTH_USER']}.</p>";
            echo "<p>You entered {$_SERVER['PHP_AUTH_PW']} as your password.</p>";
        }
        ?>
        //多用户
        <?php

        $valid_passwords = array ("mario" => "carbonell");
        $valid_users = array_keys($valid_passwords);

        $user = $_SERVER['PHP_AUTH_USER'];
        $pass = $_SERVER['PHP_AUTH_PW'];

        $validated = (in_array($user, $valid_users)) && ($pass == $valid_passwords[$user]);

        if (!$validated) {
        header('WWW-Authenticate: Basic realm="My Realm"');
        header('HTTP/1.0 401 Unauthorized');
        die ("Not authorized");
        }

        // If arrives here, is a valid user.
        echo "<p>Welcome $user.</p>";
        echo "<p>Congratulation, you are into the system.</p>";

        ?>
    2. 基于文本的身份验证

    3. 基于数据库的身份验证

    4. 基于ip的身份验证

    5. 利用PEAR：Auth_HTTP
        示例： https://pear.php.net/manual/en/package.authentication.auth-http.auth-http.example2.php
    6. 用户管理
    （1）使用CrackLib测试密码的复杂度
    
    （2）一次性URL和密码恢复
        1. 生成伪随机值
            $id = md5(uniqid(rand(),1));
        
        2. 把这个伪造的随机值和用户账号关联，发送邮件告诉用户这个随机值
            $query = "UPDATE logins SET hash='$id' WHERE email='$address'";

        4. 用户访问这个随机值，重置密码
            $query = "UPDATE logins SET pswd='$pswd' WHERE hash='$id'";

+ 处理文件上传
    1. 使用PEAR: HTTP_Upload
    参考：https://pear.php.net/manual/en/package.http.http-upload.examples.php

+ PHP网络管理
    1. fsockopen() 创建socket通信连接

+ 会话处理器  （是个字典结构,session_id是字典名，里面的变量时K/v ）
    1. cookie 
    当用户访问网站时，服务器将用户的状态信息存储在本地session文件中,并把session_id发送给浏览器，浏览器保存session_id为本地的cookie Value。
    当用户对另一个页面执行请求时，服务器向用户获取该session_id，使用这个session_id找到存储的信息来验证,或获取用户的状态。

    2. cookie中的参数
    服务器返回给的cookie  ---> Response Cookies 
    客户端请求的cookie  ---> Request Cookies

    cookie 中可以设置的参数
    Name    Value   Domain  Path   Expire/Max-Age   Size    HTTP    Secure  SameSite

    3. 默认的cookie的发放方式
     下面这个几个命名都是一个东西，只是在不同场景中叫法不一样而已
     (浏览器)Cookies Value == session_id  ==  SID == PHPSESSID

    1. 浏览器请求页面,如果本地储存的有cookie Value 会在http请求头部携带一起请求,否则 session_id = Null

        浏览器 请求  Request Headers （本地保存有 session_id时）
            GET /php/index.php HTTP/1.1
            Host: 127.0.0.1
            Cookie: PHPSESSID=222226666

    2. 服务器页面 session_start()
        （1） 如果收到浏览器发过来的cookie Value,不向浏览器下发 cookie Value
        （2） 如果没有收到浏览器发送的cookie Value，就初始化一个session_id 给浏览器下发 cookie Value

            服务器返回 Response Headers （服务器下发 session_id时）
                HTTP/1.1 200 OK
                X-Powered-By: PHP/5.6.24
                Set-Cookie: PHPSESSID=222226666; path=/
                Expires: Thu, 19 Nov 1981 08:52:00 GMT
                Server: lighttpd/1.4.39

    3. 服务器初始化 session_id
        1. php.ini中 
        session.save_handler = files //指定了 session存放形式 文件
        session.save_path = "/tmp"  //指定了 session_id文件存放路径

        2. session文件存放路径
        会根据session_id 创建session文件,比如 session_id == 222226666
        默认session文件为
        /tmp/sess_222226666

        3. 如果session中没有绑定任何变量，默认初始化的是个空文件

    4. 注册会话变量
        在服务端执行
        $_SESSION['username'] = 'ljq';
        等操作
        其实是向session文件中写入
        $>cat /tmp/sess_222226666
        username|s:3:"ljq11111";# 
        （这种方式很像个字典类型，文件名是字典名，里面储存的是key/Value）

    5. 获取变量
        因为浏览器，会自动把session_id 发给服务器，相当于发送请求时  先告诉服务器他是谁 
        服务器 获取浏览器发送的session_id 会找到 /tmp/sess_$session_id文件 
        如果页面中是 echo "$_SESSION['username']"
        这时服务器会 从/tmp/sess_$session_id 中获取 username 
    
    6. 销毁session
        session_unset()   ----> 清空 /tmp/sess_$session_id 使变为空文件
        session_destroy()  ---> 删除 /tmp/sess_$session_id

        注意：不管使用任何，浏览器中的cookie Value不会被销毁

    7. 设置和获取session_id
        session_id("222226666")  //指定session_id 为222226666

    8. 撤销会话变量
        session_unset($_SESSION['username']);
        //这只会删除 username这个key的值 
    
    9. 自定义session储存方法 比如：redis 

+ 模版化 Smary |symfony 采用的 twig | Laravel 采用的 Blade 