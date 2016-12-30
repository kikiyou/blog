1. shell 监控

#!/bin/bash
# Author:SuperNic
# DateTime:2013-09-26
Inotify="/opt/fonsview/data/media/CDN/"
${Inotify} -mrq -e create /opt/fonsview/data/media/CDN/ | while read Path Events FileName
do
    chmod 755 ${Path}${FileName}
done