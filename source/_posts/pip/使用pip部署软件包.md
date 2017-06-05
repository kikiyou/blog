mkdir -p ~/.pip/

vim ~/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
#####

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

前提条件 先安装pip
可以使用pip 安装本地的软件包。

离线安装pip
python pip-9.0.1-py2.py3-none-any.whl/pip install --no-index pip-9.0.1-py2.py3-none-any.whl

生成软件包版本:
pip freeze  > requirements.txt

下载对应的软件包:
pip install --download /path/to/download/to_packagename

下载源码包
pip download --no-binary :all:  "requests[security]"
pip download -r python_3rd/requirements.txt --trusted-host mirrors.aliyun.com

安装对应的软件包:
pip install -r python_3rd/requirements.txt  --no-index --find-links=file:///opt/fonsview/3RD/python_3rd/
pip install --no-index --find-links="/path/to/downloaded/dependencies" packagename




如下 为pip下载的软件包：
-rw-r--r-- 1 root root    52158 12月 23 22:31 APScheduler-3.2.0-py2.py3-none-any.whl
-rw-r--r-- 1 root root     5151 12月 23 22:31 backports.ssl_match_hostname-3.4.0.2.tar.gz
-rw-r--r-- 1 root root    46238 12月 23 22:31 Beaker-1.5.4.tar.gz
-rw-r--r-- 1 root root  1252861 12月 23 22:32 boto-2.34.0-py2.py3-none-any.whl
-rw-r--r-- 1 root root   190989 12月 23 22:32 Cheetah-2.4.4.tar.gz
-rw-r--r-- 1 root root    32318 12月 23 22:35 configobj-4.7.2.tar.gz
-rw-r--r-- 1 root root    29213 12月 23 22:35 confluent-kafka-0.9.2.tar.gz
-rw-r--r-- 1 root root   230369 12月 23 22:35 coverage-3.6b3.tar.gz
-rw-r--r-- 1 root root  6392924 12月 23 22:35 Cython-0.25.1-cp27-cp27mu-manylinux1_x86_64.whl
-rw-r--r-- 1 root root    30333 12月 23 22:35 decorator-3.4.0.tar.gz
-rw-r--r-- 1 root root    10889 12月 23 22:35 di-0.3.tar.gz
-rw-r--r-- 1 root root    17697 12月 23 22:37 funcsigs-1.0.2-py2.py3-none-any.whl
-rw-r--r-- 1 root root    14010 12月 23 22:37 futures-3.0.5-py2-none-any.whl
-rw-r--r-- 1 root root    31278 12月 23 22:37 iniparse-0.4.tar.gz
-rw-r--r-- 1 root root    28459 12月 23 22:38 IPy-0.75.tar.gz
-rw-r--r-- 1 root root     6096 12月 23 22:38 jsonpatch-1.2.tar.gz
-rw-r--r-- 1 root root     7203 12月 23 22:38 jsonpointer-1.9-py2-none-any.whl
-rw-r--r-- 1 root root   193353 12月 23 22:38 kafka_python-1.3.1-py2.py3-none-any.whl
-rw-r--r-- 1 root root   158105 12月 23 22:38 kitchen-1.1.1.tar.gz
-rw-r--r-- 1 root root  3335355 12月 23 22:40 lxml-3.2.1.tar.gz
-rw-r--r-- 1 root root   413563 12月 23 22:40 M2Crypto-0.21.1.tar.gz
-rw-r--r-- 1 root root   407434 12月 23 22:40 Mako-0.8.1.tar.gz
-rw-r--r-- 1 root root   279760 12月 23 22:40 Markdown-2.4.1.tar.gz
-rw-r--r-- 1 root root    10911 12月 23 22:40 MarkupSafe-0.11.tar.gz
-rw-r--r-- 1 root root 15325838 12月 23 22:41 numpy-1.11.2-cp27-cp27mu-manylinux1_x86_64.whl
-rw-r--r-- 1 root root   523304 12月 23 22:42 Paste-1.7.5.1.tar.gz
-rw-r--r-- 1 root root  1408539 12月 23 22:42 Pillow-2.0.0.zip
-rw-r--r-- 1 root root    28053 12月 23 22:42 prettytable-0.7.2.zip
-rw-r--r-- 1 root root    36516 12月 23 22:42 pyasn1-0.1.9-py2.py3-none-any.whl
-rw-r--r-- 1 root root    70337 12月 23 22:42 pycurl-7.19.0.tar.gz
-rw-r--r-- 1 root root   672870 12月 23 22:43 Pygments-2.0.2-py2-none-any.whl