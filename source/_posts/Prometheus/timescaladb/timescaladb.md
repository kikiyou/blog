# timescaladb 使用

1. 使用postgrep 10
2. 下载timescaledb
wget https://timescalereleases.blob.core.windows.net/rpm/timescaledb-0.9.2-postgresql-10-0.x86_64.rpm

sudo yum install timescaledb


## postgresql安装

1. 下载
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm


2. 安装客户端
yum install postgresql10

3. 安装server
yum install postgresql10-server


4. 初始化数据库，并且使用开机启动

/usr/pgsql-10/bin/postgresql-10-setup initdb
systemctl enable postgresql-10
systemctl start postgresql-10

5. 默认存储路径
/var/lib/pgsql

6. hawaii主机分区
(0) 查看分区情况
lsblk

(1) 分区
parted /dev/sdq

mklabel gpt
mkpart 1
ext4
1 100%

(2) 重载分区表
partx  -u /dev/sdq

(3) 使用lvm
pvcreate /dev/sdq1

添加到卷组：
vgextend vg_csk /dev/sdq1

创建新的逻辑卷：
lvcreate -l 100%VG -n disk2 vg_csk

格式化：
mkfs.xfs /dev/mapper/vg_csk-disk2

(4) 复制数据，挂载分区
mount -t  xfs /dev/mapper/vg_csk-disk2 /mnt/

mv /var/lib/pgsql/*  /mnt/

[root@hawaii 10]# ll -d /var/lib/pgsql/
drwx------ 2 postgres postgres 26 May 13 18:40 /var/lib/pgsql/


umount /mnt/

mount -t  xfs /dev/mapper/vg_csk-disk2 /var/lib/pgsql


[root@hawaii 10]# ll -d /var/lib/pgsql
drwxr-xr-x 3 root root 39 May 13 18:40 /var/lib/pgsql

chown postgres:postgres /var/lib/pgsql


(5) 使用开机挂载
vi /etc/fstab
/dev/mapper/vg_csk-disk2  /var/lib/pgsql                 xfs     defaults        0 0


(6) 添加timescaledb扩展
vi /var/lib/pgsql/10/data/postgresql.conf
shared_preload_libraries = 'timescaledb'


二、
pg_prometheus：
docker pull timescale/pg_prometheus





prometheus-postgresql-adapter：
docker pull timescale/prometheus-postgresql-adapter



[root@li1604-128 ~]# docker save timescale/pg_prometheus > pg_prometheus.tar
[root@li1604-128 ~]# docker save timescale/prometheus-postgresql-adapter > prometheus-postgresql-adapter.tar


下载：
http://7xw819.com1.z0.glb.clouddn.com/prometheus-postgresql-adapter.tar

http://7xw819.com1.z0.glb.clouddn.com/pg_prometheus.tar


cat pg_prometheus.tar  | docker load


启动：
docker run --name pg_prometheus -d -p 5432:5432 timescale/pg_prometheus:latest postgres \
      -csynchronous_commit=off


docker run --name prometheus_postgresql_adapter --link pg_prometheus -d -p 9201:9201 \
 timescale/prometheus-postgresql-adapter:latest \
 -pg-host=pg_prometheus \
 -pg-prometheus-log-samples


pg_prometheus 编译：
yum install postgresql-devel

[root@hawaii opt]# ln -s /usr/pgsql-10/bin/pg_config /usr/bin/pg_config


[root@hawaii pg_prometheus]# make
pg_prometheus.so
[root@hawaii pg_prometheus]# make install 
/usr/bin/mkdir -p '/usr/pgsql-10/lib'
/usr/bin/mkdir -p '/usr/pgsql-10/share/extension'
/usr/bin/mkdir -p '/usr/pgsql-10/share/extension'
/usr/bin/install -c -m 755  pg_prometheus.so '/usr/pgsql-10/lib/pg_prometheus.so'
/usr/bin/install -c -m 644 .//pg_prometheus.control '/usr/pgsql-10/share/extension/'
/usr/bin/install -c -m 644 .//sql/pg_prometheus--0.0.1.sql  '/usr/pgsql-10/share/extension/'



psql --username=postgres