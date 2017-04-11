从GoLang的目前的中文原创/中译本书籍数量来看，GoLang真的太不被关注了，看看Swift都多少本中文书了：
1) Go语言程序设计 // 某牛翻译
2) Go Web编程 // Beego作者原创
3) Go 并发编程实战 // 新书，没看呢，怎么样？
4) Go语言编程 // 某牛原创
5) Go语言云动力 // 新加坡人编写，体会一下异域语言风格，挺有意思
6) 代码的未来（第3.2章Go）// 松本行弘认为GoLang的switch语法借鉴了Ruby

------------------------------
1. go env
2. go编译目录
bin  （存放编译生成的可执行文件）
pkg  （存放编译后生成的包文件）
src  （存放项目源码）

3. go编程基础

go get： 获取远程的包 （需提前安装git）
go run: 直接运行程序
go build: 测试编译，检查是否编译错误
go fmt：编译包文件并编译整个程序
go test:运行测试文件
go doc：查看文档

sudo dnf install golang-godoc
godoc -http=:8080


4. 编译  
go install 
go build
go run


go 内置关键字（25均为小写）

break default func interface select
case defer go map struct
chan else goto package switch
const fallthrough if range type
continue for import return var


go 注释方法

+ // 单行注释
+ /**/ 多行注释


只有在main包中可以运行，main函数

## 可见性规则
+ go语言中,使用大小写来决定 常量、变量、类型、接口、结构和函数 是否可以被外部包所调用：
根据约定： 
函数名 首字母 小写 即为 private
函数名字 首字母大写 即为 pubilc


导包与变量定义的简写
const （
PI = 3.14
count = 1
）

var（
name = "gopher"
name1 = "cc"
）
type (

)
import (
    fmt
)

变量声明偷懒法，用：代替var关键字
var a = 1   ===>   a:=1


循环语句 for：

+ 第一种形式：
func main() {
	a := 1
	for {
		a++
		if a > 3 {
			break
		}
	}
	fmt.Println(a)
}
------------
+ 第二种形式
func main(){
	a := 1
	for a <= 3 {
		a++
	}
	fmt.Println(a)
}
----------
+ 第三种形式
func main() {
	a := 1
	for i := 0; i < 3; i++ {
		a++
	}
	fmt.Println(a)
}

# 跳转语句  需要和标签配合
break goto continue 是和label标签使用

# 数组
a := [...]int{1, 2, 3, 4, 5}
使用new关键字 创建数组
p := new（[10]int）

# map 相当于字典
var m map[int]string
m = map[int]string{}
m = make(map[int]string{})

for k,v := range map{
    map[k] = i
} 

+ defer 相当于 析构

使用 panic和recover 做错误捕捉
panic(" Panic in B")
defer func(){
    if err := recover(); err != nil{
        fmt.Println("Recover in B")
    }
}