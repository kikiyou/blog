# golang 包管理工具

1. glide  --推荐这个
2. gvt


gvt简单，直接 
gvt fetch github.com/fatih/color
把依赖下载即可



godep :
如果要增加新的依赖包：

Run go get foo/bar
Edit your code to import foo/bar.
Run godep save (or godep save ./…).
如果要更新依赖包：

Run go get -u foo/bar
Run godep update foo/bar. (You can use the … wildcard, for example godep update foo/…).


glide:
1. glide create   创建新项目，生成glide.yaml
2. glide install  根据glide.lock，copy 依赖到 vendor
3. glide update  # 更新依赖包信息，更新glide.lock

glide 添加一个包
export GOPATH=/home/monkey/go
glide get github.com/kr/pty


glide 使用教程：
https://gocn.vip/article/393