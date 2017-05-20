1. groovy里的任何变量必须是number，string或可序列化的类型
否则需要写成函数，使用@NonCPS  或 最后至为null

2. 每次sh的命令for循环，只执行一步
可以使用如下方式解决：
@NonCPS
def createScript(){
    def cmd=""
    for (i in [ 'a', 'b', 'c' ]) {
        cmd = cmd+ "echo $i"
    }
    writeFile file: 'steps.groovy', text: cmd
}
Then call the function like

createScript()
load 'steps.groovy'