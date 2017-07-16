#换用中国软件源
$ td-agent-gem sources --add http://gems.ruby-china.org/ --remove https://rubygems.org/
$ td-agent-gem sources -l

############不需要
卸载：
yum remove ruby ruby-devel

升级ruby版本：
http://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.1.tar.gz

wget http://7xw819.com1.z0.glb.clouddn.com/ruby-2.4.1-1.el7.centos.x86_64.rpm

yum install ruby-devel.x86_64 rubygems -y 
###################
td-agent-gem install fluent-plugin-elasticsearch

td-agent-gem install fluent-plugin-concat

vi /etc/profile
修改成022

或者 修改
/etc/init.d/td-agent
umask 022

查看当前的安装环境变量
td-agent-gem environment

chmod 755 /usr/lib64/ruby/gems/2.4.0 -R

###解除安全加固
chattr -i /etc/passwd
chattr -i /etc/shadow
chattr -i /etc/group
chattr -i /etc/gshadow

chattr -R -i /bin /boot /lib /sbin
chattr -R -i /usr/bin /usr/include /usr/lib /usr/sbin
chattr -a /var/log/messages /var/log/secure /var/log/maillog
###


172.16.6.16 es.fonsview.local
127.0.0.1 fluentdhost.fonsview.local


-------------------------
ExecStart=/usr/bin/dockerd \
--log-driver=fluentd \
--log-opt fluentd-async-connect \
--log-opt fluentd-address=unix:///tmp/fluentd.sock \
--log-opt labels=io.kubernetes.pod.namespace,io.kubernetes.container.name,io.kubernetes.pod.name


<source>
  @type unix
  path /tmp/fluentd.sock
</source>

-----------------------------
# fluentd/conf/fluent.conf
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>


#<filter docker.**>
#  @type parser
#  format json # apache2, nginx, etc...
#  key_name log
#  reserve_data true
#</filter>

<filter docker.**>
  @type concat
  key log
  stream_identity_key container_id
  multiline_start_regexp /^-e:2:in `\/'/
  multiline_end_regexp /^-e:4:in/
</filter>

<match docker.**>
   @type elasticsearch
   @log_level info
   include_tag_key true
   host es.fonsview.local
   port 9200
   logstash_format true
   logstash_prefix fluentd
   logstash_dateformat %Y%m%d
   include_tag_key true
   type_name access_log
   tag_key @log_name
   # Set the chunk limit the same as for fluentd-gcp.
   buffer_chunk_limit 2M
   # Cap buffer memory usage to 2MiB/chunk * 32 chunks = 64 MiB
   buffer_queue_limit 32
   flush_interval 5s
   # Never wait longer than 5 minutes between retries.
   max_retry_wait 30
   # Disable the limit on the number of retries (retry forever).
   disable_retry_limit
   # Use multiple threads for processing.
   num_threads 8
</match>