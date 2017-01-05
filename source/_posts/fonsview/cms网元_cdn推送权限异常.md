bug 找到了 是root用户的umask  改成0022就好了，加固后改成了0077
在
/etc/bashrc
/etc/profile
##
    # By default, we want umask 077
    # Current threshold for system reserved uid/gids is 200
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
       umask 077
    else
       umask 077
    fi

#默认是 
    if [ $UID -gt 199 ] && [ "`id -gn`" = "`id -un`" ]; then
       umask 002
    else
       umask 022
    fi

##
cat /etc/login.defs
umask  默认是077 被修改为了  UMASK 027

####

1. shell 监控

#!/bin/bash
# yum install inotify-tools -y
# DateTime:2013-09-26
Inotify="/usr/bin/inotifywait"
${Inotify} -mrq -e create,MOVED_TO /opt/fonsview/data/media/CDN/ | while read Path Events FileName
do
    chmod 755 ${Path}${FileName}
done



-----------------
监控得到这个xml是这样创建出来的
/opt/fonsview/data/media/CDN/CD/fonsview_hls/20170103/ CREATE Movie_REGIST_fonsview_hls_21_20170103104934_774025.xml.tmp
/opt/fonsview/data/media/CDN/CD/fonsview_hls/20170103/ OPEN Movie_REGIST_fonsview_hls_21_20170103104934_774025.xml.tmp
/opt/fonsview/data/media/CDN/CD/fonsview_hls/20170103/ MODIFY Movie_REGIST_fonsview_hls_21_20170103104934_774025.xml.tmp
/opt/fonsview/data/media/CDN/CD/fonsview_hls/20170103/ CLOSE_WRITE,CLOSE Movie_REGIST_fonsview_hls_21_20170103104934_774025.xml.tmp
/opt/fonsview/data/media/CDN/CD/fonsview_hls/20170103/ MOVED_FROM Movie_REGIST_fonsview_hls_21_20170103104934_774025.xml.tmp
/opt/fonsview/data/media/CDN/CD/fonsview_hls/20170103/ MOVED_TO Movie_REGIST_fonsview_hls_21_20170103104934_774038.xml