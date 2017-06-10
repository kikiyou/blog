
# go 单元测试
[参考](https://github.com/astaxie/build-web-application-with-golang/blob/master/zh/11.3.md)


## 下载

go get -v github.com/cweill/gotests


gotest_test.go:这是我们的单元测试文件，但是记住下面的这些原则：

文件名必须是_test.go结尾的，这样在执行go test的时候才会执行到相应的代码
你必须import testing这个包
所有的测试用例函数必须是Test开头
测试用例会按照源代码中写的顺序依次执行
测试函数TestXxx()的参数是testing.T，我们可以使用该类型来记录错误或者是测试状态
测试格式：func TestXxx (t *testing.T),Xxx部分可以为任意的字母数字的组合，但是首字母不能是小写字母[a-z]，例如Testintdiv是错误的函数名。
函数中通过调用testing.T的Error, Errorf, FailNow, Fatal, FatalIf方法，说明测试不通过，调用Log方法用来记录测试的信息。


然后我们执行`go test -v`，就显示如下信息，测试通过了：

	=== RUN Test_Division_1
	--- PASS: Test_Division_1 (0.00 seconds)
		gotest_test.go:11: 第一个测试通过了
	=== RUN Test_Division_2
	--- PASS: Test_Division_2 (0.00 seconds)
		gotest_test.go:20: one test passed. 除数不能为0
	PASS
	ok  	gotest	0.013s
