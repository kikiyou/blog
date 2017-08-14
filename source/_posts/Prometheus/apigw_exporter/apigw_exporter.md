访问地址：
http://172.16.18.5:31600/epg_server/mango_tv

[root@apigw-129285491-5x3kr /]# redis-cli --raw keys "*"
1502692613

root@apigw-129285491-5x3kr /]# redis-cli LRANGE  $(redis-cli --raw keys "*") 0 -1 
1) "desktop|getHomepage|192.168.169.248|GET|200|603|493|0.007|0.007|2017-08-14T14:39:49+08:00"
2) "desktop|getHomepageCfg|192.168.169.248|GET|200|581|17882|0.013|0.013|2017-08-14T14:39:49+08:00"
3) "weather|getWeather|192.168.169.248|GET|200|559|457|0.004|0.004|2017-08-14T14:39:49+08:00"
4) "mssServiceId|mss_routlist|192.168.36.174|GET|200|542|9461|0.029|0.029|2017-08-14T14:39:49+08:00"



1. 客户端 获取redis的信息
2. 封装到agetn中
3. server 获取agent中的数据
4. grafana展示



使用cnpm，以后用cnpm速度快
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"


1. json --> import "github.com/tidwall/gjson"
2. redis --> import "github.com/go-redis/redis"

写之前再看下这个：
http://yunlzheng.github.io/2017/07/07/prometheus-exporter-example-go/