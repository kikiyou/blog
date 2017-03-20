20170309 18:50:12.588.735 hls_view NULL|10.16.193.3|stagefright/1.2 (Linux;Android 4.0.3) Mozilla/5.0(iPad; U; CPU iPhone OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B314 Safari/531.21.10 QuickTime|HLJCMS|10000001000000000002000000329037|HLJCMSIPTV/10000001000000000002000000329037|00|1583|20170309184940|20170309184554|20170309184940|226|63718|6235667738212441710|0|34|1|0|1302|1316|2098|4397|5504|0|0|34|34|0|0|6|0|6|65248124|0|0|0|35|0[hls_session_ctl.c:90]


SS_DATE %{YEAR}%{MONTHNUM}%{MONTHDAY}
SS_DATESTAMP %{SS_DATE } %{TIME}.%{INT}
%{SS_DATESTAMP:timestamp}%{SPACE}%{WORD:protocol}%{SPACE}%{WORD:userid}\|%{IPV4:userip}\|
-----------------------------------


SS_DATE %{YEAR}%{MONTHNUM}%{MONTHDAY}
SS_DATESTAMP %{SS_DATE } %{TIME}.%{INT}
SS_AGENT .*?
RELATIVEURL %{WORD}/%{NUMBER}

SS_HLS_LOG %{WORD:STBID}\|%{IPV4:STBIP}\|%{SS_AGENT:UserAgent}\|%{WORD:CMSID}\|%{NUMBER:ContentID}\|%{RELATIVEURL:RelativeUrl}\|%{NUMBER:ServiceType}\|%{NUMBER:bitrate}\|%{NUMBER:RecordTime}\|%{NUMBER:BeginTime}\|%{NUMBER:EndTime}\|%{NUMBER:duration}\|%{NUMBER:volume}\|%{NUMBER:transactionID}\|%{NUMBER:MainM3UResTime}\|%{NUMBER:SubM3UResTime}\|%{NUMBER:MediaResTime}\|%{NUMBER:SendBufFullCount}\|%{NUMBER:FirstMediaSendTime}\|%{NUMBER:SecondMediaSendTime}\|%{NUMBER:ThirdMediaSendTime}\|%{NUMBER:AvgMediaSendTime}\|%{NUMBER:MaxMediaSendTime}\|%{NUMBER:AvgMediaReqTime}\|%{NUMBER:MaxMediaReqTime}\|%{NUMBER:AvgM3UResTime}\|%{NUMBER:MaxM3UResTime}\|%{NUMBER:Res3XXCount}\|%{NUMBER:Res4XXCount}\|%{NUMBER:Res5XXCount}\|%{NUMBER:SendMediaErrorCount}\|%{NUMBER:CloseByPeerCount}\|%{NUMBER:BytesHit}\|%{NUMBER:BitrateHighChange}\|%{NUMBER:EachBitrateMediaCount}\|%{NUMBER:TotalMediaCount}\|%{NUMBER:SendBitrateLowCount}\|%{NUMBER:Nodeid}