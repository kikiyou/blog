# nginx负载zabbix_api为grafana加速

grafana 调用zabbix的api 时顺序的，可以前面架个nginx把请求变为并行的

nginx 配置:

[root@SBB-HX-F4-IPTV-Server-Zabbix01 ~]# cat /etc/nginx/conf.d/zabbix_upstream.conf 
upstream api.z.hb.rhel.cc {
      server 127.0.0.1:81 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:82 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:83 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:84 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:85 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:86 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:87 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:88 max_fails=3 fail_timeout=3s weight=9;
      server 127.0.0.1:89 max_fails=3 fail_timeout=3s weight=9;
}

server{ 
    listen 8081; 
    server_name api.z.hb.rhel.cc; 
    location / { 
        proxy_pass         http://api.z.hb.rhel.cc; 
        proxy_set_header   Host             $host; 
        proxy_set_header   X-Real-IP        $remote_addr; 
        proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for; 
    } 
}

server { 
    listen 81;
    listen 82;
    listen 83;
    listen 84;
    listen 85;
    listen 86;
    listen 87;
    listen 88;
    listen 89;

    location /zabbix { 
    alias /usr/share/zabbix;
    index index.php index.php ; 
}  
    location ~ \.php$ { include /etc/nginx/fastcgi_params;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /usr/share/$fastcgi_script_name; 
        fastcgi_connect_timeout 600;
        fastcgi_send_timeout 600;
        fastcgi_read_timeout 600;
        fastcgi_buffer_size 256k;
        fastcgi_buffers 16 256k;
        fastcgi_busy_buffers_size 512k;
        fastcgi_temp_file_write_size 512k;
  } 
}

