# cms 注入流程

## 添加contenID 管理
    1. 系统配置 ->  contenID管理 -> 添加 ->

                            - 批次： 1234
                            - contenID预分配数量： 200
                            - 执行时间 -> 选当前时间
    2. CP/SP -> CP -> 添加 -> （注：CP ID与CMM设置中的CMSID要一致对应）

                            - CP ID: fonsview_hls
                            - 名称*: fonsview_hls
                            - CP内容编号*: 00000001
    3. CP/SP -> SP -> 添加 ->

                            - SP ID*: fonsview_hls
                            - 名称*: fonsview_hls
                            - CP内容编号*: 00000002
                            - 内容提供商: 全选
    4. 添加角色 -> 

                - 内容名称： monkey
                - 描述: monkey test
                - 设置权限： 全选
    5. 添加用户 -> 选择 -> CP
                            - CP: fonsview_hls
                            - 登录帐号: monkey

    6. 系统管理 -> FTP服务器 -> 添加/修改 ->
                                        
                                        - 服务器名称: ott-ftp
                                        - 主机名或IP: 172.16.199.119
                                        - 端口: 21
                                        - 用户名: ftpuser
                                        - 密码: ftpuser
                                        - 根目录: /opt/fonsview/data/media     (注:ftp那里配置好chroot后,这里根即为/opt/fonsview/data/media)

## CDN 分发

    1. 分发管理 -> 分发配置 -> CDN分发 ->

                          - 配置名称*: cd
                          - 接口类型: CD
                          - 启用: 是
                          - 流量控制: 10
                          - 超时时长: 60
                          - 分发地址: http://172.16.199.120:8190/ContentDeployReq   (CMM地址)
                          - FTP服务器地址: ott-ftp
                          - 播放信息:  (如下都为SS地址)
                            - RR_IPTV  rtsp://172.16.199.120:554
                            - RR_HPD   http://172.16.199.120:8106
                            - RR_HLS   http://172.16.199.120:8112
##  VOD 注入
    1. 点播放管理 -> 合集列表 -> 添加 -> 添加合集
    2. 点播放管理 -> 合集列表 -> 列表 -> 在刚才添加的合集上 -选 操作 -> 分集管理
                            - 添加 片源  
                            - 链接: ftp://anonymous:anonymous@172.16.200.250/Media/1flora/vod/qianlizhiwai/index.m3u8




## 日志查看:
 
+ cms 的log

1. cms 接收到用户的注入 信息

    [root@fonsview log]# cat cms.log  | grep "MediaContentInterface"
    02/12/2016 17:01:12 http-bio-6600-exec-8  INFO MediaContentInterface:137 - received json is:{"id":0,"createDate":"2016/12/02 17:01:12","validTime":null,
    "hdPrice":0.0,"price":0.0,"flag":0,"downloadUrl":"ftp://anonymous:anonymous@172.16.200.250/Media/1flora/vod/qianlizhiwai/index.m3u8"
    ...

2. 添加好分集
    ...
    02/12/2016 17:01:12 http-bio-6600-exec-8  INFO MediaContentInterface:170 - add mediaContent successfully
    02/12/2016 17:01:12 http-bio-6600-exec-8  INFO MediaContentInterface:962 - mediacontent id is:2

3. cms 创建REGIST xml 文件
02/12/2016 18:37:00 schedulerFactoryBean_Worker-10 DEBUG Create2CdnXmlFile:284 - begin create movie REGIST xml file
02/12/2016 18:37:00 schedulerFactoryBean_Worker-10  INFO SendCdMessage:137 - CMSID=mango_hls,SOPID=cd,CorrelateID=40b56b8e424845028c5ae1b1af956218,ContentMngXMLURL=ftp://ftpuser:ftpuser@172.16.199.119:21/CDN/CD/mango_hls/20161202/Movie_REGIST_mango_hls_4_20161202183700_020289.xml

4. cmm 下载 xml (cmm log)
2016-12-05 19:21:49,041 INFO  CMS distribute info:CMSID[Mango],SOPID[cd],CorrelateID[bbb81a4232ae44759e5d9266f9f6077d],ContentMngXMLURL[ftp://ftpuser:ftpuser@172.16.199.120:21/CDN/CD/Mango/20161205/Movie_UPDATE_Mango_1_20161205192149_909034.xml] [ContentDeployReqService.java:35]
2016-12-05 19:21:49,042 INFO  Insert CD request to DB, call procedure SpContentDeployReqAdd(Mango,cd,bbb81a4232ae44759e5d9266f9f6077d,ftp://ftpuser:ftpuser@172.16.199.120:21/CDN/CD/Mango/20161205/Movie_UPDATE_Mango_1_20161205192149_909034.xml) [MessageQueueManager.java:66]
2016-12-05 19:21:49,044 INFO  Insert CD request to DB success [MessageQueueManager.java:78]
2016-12-05 19:21:49,044 INFO  addRequestMessage rlt = true [ContentDeployReqService.java:58]
2016-12-05 19:21:49,044 INFO  CMM receive success and return [ContentDeployReqService.java:70]
2016-12-05 19:21:49,712 INFO  parser thread:request info--->CMSID:Mango,SOPID:cd,ftpaddress:ftp://ftpuser:ftpuser@172.16.199.120:21/CDN/CD/Mango/20161205/Movie_UPDATE_Mango_1_20161205192149_909034.xml,CorrelateID:bbb81a4232ae44759e5d9266f9f6077d [XmlParserThread.java:47]
2016-12-05 19:21:49,712 INFO  getContentMngXMLURLftp://ftpuser:ftpuser@172.16.199.120:21/CDN/CD/Mango/20161205/Movie_UPDATE_Mango_1_20161205192149_909034.xml [XmlParserThread.java:67]
2016-12-05 19:21:49,712 INFO  download:ftp://ftpuser:ftpuser@172.16.199.120:21/CDN/CD/Mango/20161205/Movie_UPDATE_Mango_1_20161205192149_909034.xml [FtpUtils.java:32]
2016-12-05 19:21:49,713 INFO  download try:ftp://ftpuser:ftpuser@172.16.199.120:21/CDN/CD/Mango/20161205/Movie_UPDATE_Mango_1_20161205192149_909034.xml [FtpUtils.java:40]
2016-12-05 19:21:49,715 INFO  connect try:21 [FtpUtils.java:42]
2016-12-05 19:21:49,719 INFO  login try:ftpuser,ftpuser [FtpUtils.java:44]
2016-12-05 19:21:49,719 INFO  true [FtpUtils.java:49]
2016-12-05 19:21:49,719 INFO  257 "/"
 [FtpUtils.java:53]
2016-12-05 19:21:49,719 INFO  /CDN/CD/Mango/20161205 [FtpUtils.java:54]
2016-12-05 19:21:49,777 INFO  CD type:Movie [AdiXmlParser.java:65]
2016-12-05 19:21:49,778 INFO  FileURL: ftp://anonymous:anonymous@172.16.200.250/Media/1flora/vod/qianlizhiwai/index.m3u8 [AdiXmlParser.java:529]
2016-12-05 19:21:49,778 INFO  CPContentID: Mango [AdiXmlParser.java:529]
2016-12-05 19:21:49,778 INFO  Duration: 0 [AdiXmlParser.java:529]
2016-12-05 19:21:49,778 INFO  FileSize:  [AdiXmlParser.java:529]
2016-12-05 19:21:49,779 ERROR  can not transfor to int value [StringUtils.java:47]
2016-12-05 19:21:49,779 INFO  Domain: 1032 [AdiXmlParser.java:529]
2016-12-05 19:21:49,779 INFO  DestDRMType: 0 [AdiXmlParser.java:529]
2016-12-05 19:21:49,783 INFO  [null_00000002000000001234000000000007]add MovieInjectReq success [MovieInjectQueue.java:31]
2016-12-05 19:21:49,785 INFO  delete CD request:reqId[919] from db success [Procedure.java:137]

5. ss 收到cmm 传来的信息
20161206 14:32:10.255.442 dec11 (a593dcd4791f8d77)(0)DECI0 got GET msg from 0.0.0.0,start=0,copies=1,url=ftp://anonymous:anonymous@172.16.200.250/Media/1flora/vod/qianlizhiwai/index.m3u8,pcontent_id=00000002000000001234000000000011,provider_id=fonsview_hls,OriginProviderID=,OriginContentID=,file_type=9[deci11_fsm_msg.c:322]

6. ss 拉取 源信息

20161206 14:32:11.960.729 demi11 [a593dcd4791f8d77,    0,1006,-1]encode req len=47 url=SIZE Media/1flora/vod/qianlizhiwai/index.m3u8

7. ss 拉取完成 返回给 cmm
20161206 14:32:54.429.795 dec11 (a593dcd4791f8d77)reply complete msg to 172.16.199.120:8194,pcontent_id:00000002000000001234000000000011,provider_id:fonsview_hls,retcode=200[deci11_fsm_msg.c:1636]

8. cmm 收到 ss的返回信息
</message> [ContentDistributeRes.java:69]
2016-12-06 14:32:10,264 INFO  [fonsview_hls_00000002000000001234000000000011]Send Movie[00000002000000001234000000000011] to CDN success [MovieSessionThread.java:610]
2016-12-06 14:32:54,434 INFO  ss request uri:/OnlineNotifyReq [HttpHandlerImpl.java:794]
2016-12-06 14:32:54,435 INFO  /172.16.199.120: contentmgr request info:<?xml version="1.0" encoding="UTF-8"?>
<message>

9. cmm 将xml 文件上传到 自己的ftp  (注这里是cmm的ftp,也可以和cms共用ftp)

2016-12-06 14:32:56,206 INFO  Ftp: ftp://ftpuser:ftpuser@127.0.0.1/cmm/Mango_cd_e124f5c8a3e84b90843cd4d30958e767_1481005976170.xml [FtpUtils.java:317]
2016-12-06 14:32:56,207 INFO  ftp: 127.0.0.1:21 [FtpUtils.java:331]
2016-12-06 14:32:56,209 INFO  ftp: ftpuser:ftpuser [FtpUtils.java:336]
2016-12-06 14:32:56,214 INFO  ftp Reply: 230 [FtpUtils.java:341]
2016-12-06 14:32:56,216 INFO  upload ftp successfully. [FtpUtils.java:403]
2016-12-06 14:32:56,217 INFO  cd Result xml upload end ... [WsCdClientThread.java:67]

10. cms 接受到到 cmm传来的消息
06/12/2016 14:32:56 qtp596155362-37  INFO ReplyCD:75 - received message from CMM: CMSID=Mango, SOPID=cd, CorrelateID=e124f5c8a3e84b90843cd4d30958e767, ResultCode=0, ErrorDescription=null, ContentMngXMLURL=ftp://ftpuser:ftpuser@127.0.0.1/cmm/Mango_cd_e124f5c8a3e84b90843cd4d30958e767_1481005976170.xml 
06/12/2016 14:32:56 qtp596155362-37 DEBUG ReplyCD:117 - >>>>>process cdn task sucessfully by cmm correlateId=e124f5c8a3e84b90843cd4d30958e767, contentId=00000002000000001234000000000011

