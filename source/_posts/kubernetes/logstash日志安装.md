chattr -i /usr/bin
chattr -i /usr/bin/*
chattr -i /etc/alternatives/
chattr -i /etc/alternatives/*
chattr -i /usr/lib/*


chattr -i /etc/shadow
chattr -i /etc/shadow-
chattr -i /etc/gshadow
chattr -i /etc/passwd

chattr -i /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.75-2.5.4.2.el7_0.x86_64/jre/bin/
chattr -i /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.75-2.5.4.2.el7_0.x86_64/jre/bin/*


http://7xw819.com1.z0.glb.clouddn.com/jre-8u131-linux-x64.rpm


/etc/logstash/conf.d/1-docker.conf

input {
  gelf {
    type => docker
  }
}


output {
       elasticsearch {
               hosts => "es.fonsview.local:9200"
    #           index => "elasticsearch"
               index => "logstash-%{type}-%{+YYYY.MM.dd}"
       }
 }
------------------------------------
172.16.6.16 es.fonsview.local
127.0.0.1 logstash.docker.fonsview.local




chattr -i /usr/lib/systemd/system/docker.service

ln -s /usr/lib/systemd/system/docker.service /etc/systemd/system/docker.service




ExecStart=/usr/bin/dockerd --insecure-registry=172.16.6.10:30088 \
--log-driver=gelf \
--log-opt gelf-address=udp://logstash.docker.fonsview.local:12201 \
--log-opt tag=node1 \
--log-opt labels=io.kubernetes.pod.namespace,io.kubernetes.container.name,io.kubernetes.pod.name
