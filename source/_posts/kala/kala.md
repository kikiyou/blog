#golang调度中心kala测试

[参考](http://www.jianshu.com/p/4267ea97351d)

前言
kala是go版本类crontab调度的服务，默认存储bolt，用redis存储时有点问题，密码为空会抛异常，修改了kala\job\storage\redis\redis.go增加了无密的方法。。

func Newnopass(address string) *DB {
    conn, err := redis.Dial("tcp", address)
    if err != nil {
        log.Fatal(err)
    }
    return &DB{
        conn: conn,
    }
}
对参数中密码为默认或者空的调用该方法，否则建立连接的时候redis.DialOption生成空结构体在redigo.Dial时会引起panic: runtime error: invalid memory address or nil pointer dereference报错。

kala启动，修改后重新go build项目

//密码为空启动
[slview@YFTEST1 kala]$ ./kala run -p 40001 --jobDB=redis --jobDBAddress=192.168.6.151:6379 --jobDBPassword=""
INFO[0000] Starting server on port :40001...              
//默认没密码，没修改前会默认密码是password。。
[slview@YFTEST1 kala]$ ./kala run -p 40001 --jobDB=redis --jobDBAddress=192.168.6.151:6379
INFO[0000] Starting server on port :40001...
http创建job，目标是每隔30秒采集一次思科路由器某端口的出和入流量

//create job , get job id ,can use job-id view status
curl http://127.0.0.1:40001/api/v1/job/ -d '{"epsilon": "PT10S", "command": "/slview/test/zhangqi/snmpwalk.sh", "name": "zhangqi_job", "schedule": "R/2017-06-08T11:15:00.819236718+08:00/PT30S"}'
{"id":"6973f82d-09d2-474f-630f-16d9ad27b484"}
//shell
#!/bin/sh
more snmpwalk.sh 
Dev_Ip=192.168.6.87
Comm=public
File=/slview/test/zhangqi/CI_$Dev_Ip
date >>$File
snmpwalk -v2c -c $Comm $Dev_Ip .1.3.6.1.2.1.31.1.1.1.6.1 >>$File
snmpwalk -v2c -c $Comm $Dev_Ip .1.3.6.1.2.1.31.1.1.1.10.1 >>$File
查看是否正常调度，每隔30秒生成文件正常

 tail -f CI_192.168.6.87 
2017年 06月 08日 星期四 11:15:00 CST
IF-MIB::ifHCInOctets.1 = Counter64: 1831783500
IF-MIB::ifHCOutOctets.1 = Counter64: 1033990306
2017年 06月 08日 星期四 11:15:30 CST
IF-MIB::ifHCInOctets.1 = Counter64: 1831793637
IF-MIB::ifHCOutOctets.1 = Counter64: 1033997648
2017年 06月 08日 星期四 11:16:00 CST
IF-MIB::ifHCInOctets.1 = Counter64: 1831815957
IF-MIB::ifHCOutOctets.1 = Counter64: 1034010252
2017年 06月 08日 星期四 11:16:30 CST
IF-MIB::ifHCInOctets.1 = Counter64: 1831826698
IF-MIB::ifHCOutOctets.1 = Counter64: 1034016972
2017年 06月 08日 星期四 11:17:00 CST
IF-MIB::ifHCInOctets.1 = Counter64: 1831851051
IF-MIB::ifHCOutOctets.1 = Counter64: 1034031575
2017年 06月 08日 星期四 11:17:30 CST
IF-MIB::ifHCInOctets.1 = Counter64: 1831862726
IF-MIB::ifHCOutOctets.1 = Counter64: 1034040076
查看redis存储，是一个hset

127.0.0.1:6379> hkeys kala:jobs
1) "6973f82d-09d2-474f-630f-16d9ad27b484"
可以用curl或者浏览器查看job在何时调度了程序，retry是几次

bash-4.1$ curl -s http://192.168.6.26:40001/api/v1/job/stats/6973f82d-09d2-474f-630f-16d9ad27b484/ | jq .
{
  "job_stats": [
    {
      "execution_duration": 219580517,
      "success": true,
      "number_of_retries": 0,
      "ran_at": "2017-06-08T11:15:00.819908161+08:00",
      "job_id": "6973f82d-09d2-474f-630f-16d9ad27b484"
    },
    {
      "execution_duration": 215259152,
      "success": true,
      "number_of_retries": 0,
      "ran_at": "2017-06-08T11:15:30.820510442+08:00",
      "job_id": "6973f82d-09d2-474f-630f-16d9ad27b484"
    },
    {
      "execution_duration": 129358057,
      "success": true,
      "number_of_retries": 0,
      "ran_at": "2017-06-08T11:16:00.821014506+08:00",
      "job_id": "6973f82d-09d2-474f-630f-16d9ad27b484"
    },
其他功能

kala可以设置retries和epsilon，规定重复时间内的重试次数，格式遵循标准为ISO8601，如：{"retries": 3, "epsilon": "PT10S",。。。}

删除job

curl -XDELETE http://127.0.0.1:40001/api/v1/job/6973f82d-09d2-474f-630f-16d9ad27b484/

