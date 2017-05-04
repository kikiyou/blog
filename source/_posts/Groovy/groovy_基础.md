# groovy使用

## 安装
dnf install groovy


## 概念
元编程 意思应该是指「编写能改变语言语法特性或者运行时特性的程序」。

##groovy 调用shell命令

for (i in 0..2) { print 'ho '}
println 'Merry Groovy!'

0.upto(10) { print "$it "}


print("\nI love you\n")


println "svn help".execute().getClass().name


## 安全导航操作符

str?.reverse()   如果str非空才执行

###
class Car {
    def miles = 0
    final year

    Car(theYear) { year = theYear}
}

Car car = new Car(2008)

println "Year: $car.year"
println "Miles: $car.miles"
println "Setting miles"
car.miles = 25
println "Miles: $car.miles"

## 符号重载

lst = ['hello']
lst << 'there'
println lst

## 静态导入
import static Math.random;
import static Math.random as rand;


## groovy陷阱

str1 = 'hello'
str1 = 'Hello'
${ str1 == str2 }
${ str1.is(str2) }

##闭包

pickEven(10) {println it}
pickEven(10) { evenNumber -> printlen evenNumber }

## 正则表达式

/\d*\w/ 与 "\\d*\\w*" 等价
字符串前加~表示正则，匹配规则

Groovy 提供了一对操作符: =~ 和 ==~

pattern = ~"(G|g)roovy"
text = 'Groovy is Hip'
if (text =~ pattern)
    println "match"
else
    println "no match"

if (text ==~ pattern)
    println "match"
else
    println "no match"
执行后结果:
match
no match

=~ 执行RegEx部分匹配，而==~执行RegEx精确匹配。因此，在前面的代码示例中，第一个模式匹配报告的是match,第二个是no match。

## 列表迭代
lst = [1,2,3,4,5,6,7]
lst.each { println it }

lst.collect { it * 2 }  把迭代的值 继续传给lst，相当于给每个值 * 2

##map的使用
langs = ['c++':'stroustrup','java':'Gosling','Lisp':'McCarthy']

langs['c++']
langs.'c++'

map 的引用

+ map的迭代

langs.each { entry ->
 println " $entry.key $entry.value"
}


langs.each { k,v ->
 println " $k $v"
}


## 远程调用

http://<jenkins>/script
返回页面
http://<jenkins>/scriptText
return result/System.out

远程访问
$curl --data-urlencode "script=$(<./somescript.groovy)" http://<jenkins>/scriptText
$curl --user 'username:password'
=======
pickEven(10) { evenNumber -> printlen evenNumber }
