5、开启中文支持及更正中文乱码问题
开启中文支持：
vim /usr/share/zabbix/zabbix/include/locales.inc.php
zh_CN' => array('name' => _('Chinese (zh_CN)'),        'display' => true),
将false改为true
更正中文乱码问题：
在Windows中找到所需的字体文件传到/usr/share/zabbix/fonts目录下，修改zabbix的web端/usr/share/zabbix/include/defines.inc.php将原来的字体替换掉.
#define('ZBX_GRAPH_FONT_NAME',          'graphfont'); // 45行
define('ZBX_GRAPH_FONT_NAME',           'msyhbd'); 
#define('ZBX_FONT_NAME', 'graphfont');                //93行
define('ZBX_FONT_NAME', 'msyhbd');