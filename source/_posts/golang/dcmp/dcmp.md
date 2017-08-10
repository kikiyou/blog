#dcmp 学习

runtime.GOMAXPROCS(runtime.NumCPU())

runtime.NumCPU() --> 获取当前系统的cpu核数
runtime.GOMAXPROCS() --> 设置最大的可同时使用的cpu核数


filename, _ := filepath.Abs("./config/config.yml")
/home/monkey/go/src/github.com/silenceper/dcmp/config/config.yml

输入相对路径，最后返回绝对路径



getConf 函数返回的
&{0.0.0.0:8000 [http://127.0.0.1:2379] /config   }
