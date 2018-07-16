
+ 可以参考这篇文章
https://my.oschina.net/yangchen1127/blog/1600661

+ python 调用库

https://python-nomad.readthedocs.io

安装：
pip install python-nomad

+ 不要使用exec 而要使用raw-exec,因为exce会是一个chroot换行，会copy物理主机的大量文件生成chroot环境

+ 简单任务 example.nomad

job "batch" {
  datacenters = ["dc1"]
  type = "system"

  group "batch" {
    task "batch" {
      driver = "raw_exec"
      config {
        command = "ls"
        # args    = ["/home/monkey/note.txt"]

      }
    }
  }
}

+ 启动server
$ sudo nomad agent -config server.hcl


+ 启动agent
sudo nomad agent -config client1.hcl


+ 运行
# nomad init
# nomad run example.nomad
