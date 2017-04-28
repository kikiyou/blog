$ sudo yum install initscripts fontconfig
yum install fontconfig
yum install freetype*
yum install urw-fonts

$ sudo rpm -Uvh grafana-4.1.2-1486989747.x86_64.rpm



/etc/init.d/grafana-server start

mkdir -p /var/lib/grafana/plugins
chown -R grafana:grafana /var/lib/grafana/plugins
tar xf /tmp/alexanderzobnin-zabbix-app.tar.gz  -C /var/lib/grafana/plugins

/etc/init.d/grafana-server restart