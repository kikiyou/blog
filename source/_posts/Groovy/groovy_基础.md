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