##检测数据同步
1. cms和oss同步检测
分发管理 --> 分发配置 --> BMS
                        - 配置名称: 111
                        - 接口类型: CB-
                        - 启用: 是
                        - 流量控制: 200
                        - 超时时长: 60
                        - 分发地址: http://172.16.199.120:8081/oss/rest/syncContent
                        - FTP服务器: ott-ftp
                        - 重试次数: 1
                        - CP: fonsview_hls
                        - 内容类型: 全选
添加之后
在 分发管理 --> 分发历史 --> BMS分发
可以看到很多内容

这时 打开 oss的管理地址,在
产品管理 --> 内容 能看到 有同样的信息 

2. oss和aaa同步检测
说明 cms 和 oss 同步没有问题.

这时也可以 在oss中创建一些账户,在cmsdb中的account表中也能看到相应的账户,说明oss和aaa同步数据成功.


##  模板导入
1. CMS -> EPG管理 -- > 首页模板
                    -导入首页模板 --> 导入xml

2. CMS -> EPG管理 -- > 首页配置

3. 版本控制 -> 添加 -上传apk

4. 版本列表 --> 应用程序 --> 关联


## 盒子 测试地址

1. 8个 上 键进入设置地址 
2. 输入 密码 fs123

aaa地址:http://172.16.199.120:6600/aaa/services/rest

epg地址:http://172.16.199.120:6600/epg/rest/SPM

## oss 创建账户,绑定机顶盒mac地址

1. 在oss 中创建 账户 
2. 关联机顶盒
选中这个用户 点 更换机顶盒 --从未关联的设备中,选择你的设备,进行 关联

aaa 日志中会有这样的信息,表明用户登录成功
07/12/2016 19:24:30 DEBUG AppService:230 - d8c1312a-968f-486f-b201-9107a8ebaf57 user login success ,userId:U00000013 ,fuserId:U00000013,userToken:7904E212D9D7D6F0ABF53D2ABBBFBC55


## oss 中添加epg地址
oss中资源配置 --> 添加 -> -名称 epg
                           -服务类型 epg地址 
                           - 服务器域名:http://172.16.199.120:6600/epg/rest/SPM

## 清除epg缓存
http://172.16.199.120:6600/epg/rest/SPM/V2/clearcache