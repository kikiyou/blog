# 列出所有的库
\l
\list
psql --username=postgres

列出当前的表：
\dt

ALTER USER postgres with password 'postgres';


psql --dbname=postgres  -U postgres -W


vi /var/lib/pgsql/10/data/pg_hba.conf
local   all             postgres                                md5




./prometheus-postgresql-adapter -pg.database="tutorial"  -pg.user="postgres"  -pg.password="postgres"


初始化：
http://suite.opengeo.org/docs/latest/dataadmin/pgGettingStarted/firstconnect.html


安装图像化客户端：
yum install pgadmin3.x86_64