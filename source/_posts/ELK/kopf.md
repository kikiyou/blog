# elk 插件kopf

1. 下载
git clone git://github.com/lmenezes/elasticsearch-kopf.git
cd xxxx
sudo dnf install nodejs-grunt.noarch

grunt server


运行 grunt server

Browse to http://localhost:9000/_site



./plugin install file:///tmp/elasticsearch-kopf-master.zip 
安装后
# ll /opt/fonsview/3RD/elasticsearch/plugins/kopf
可看到插件已经安装

重新 elasticsearch  （一定要重启）

访问地址：
http://172.16.6.170:9200/_plugin/kopf