# apache源码包 编译成rpm包

+ 下载页面
https://httpd.apache.org/

https://httpd.apache.org/download.cgi#apache24

+ 下载源码包
1. wget http://mirrors.hust.edu.cn/apache//httpd/httpd-2.4.25.tar.bz2

+ 编译城rpm.src

rpmbuild -ts httpd-2.4.x.tar.bz2


+ 编译成rpm包
rpmbuild -tb httpd-2.4.x.tar.bz2

注： 编译时可能有依赖



1. 
https://mirrors.aliyun.com/apache/apr/apr-1.5.2.tar.bz2

rpmbuild -tb  apr-1.5.2.tar.bz2


rpm -Uvh /root/rpmbuild/RPMS/x86_64/apr-1.5.2-1.x86_64.rpm 
rpm -Uvh /root/rpmbuild/RPMS/x86_64/apr-devel-1.5.2-1.x86_64.rpm 


2. https://nchc.dl.sourceforge.net/project/distcache/1.%20distcache-devel/1.5.1/distcache-1.5.1.tar.gz

rpmbuild --rebuild



编包：

1.  下载 apr 和 apr- 的源码包

2. 复制
[root@aaauto srclib]# cp /tmp/apr-util-1.5.4/ /root/rpmbuild/BUILD/httpd-2.4.25/srclib/apr-util -rp
[root@aaauto srclib]# cp /tmp/apr-1.5.2 /root/rpmbuild/BUILD/httpd-2.4.25/srclib/apr -rp

3. vi  /root/rpmbuild/SPECS/httpd.spec  添加
%configure \
        --enable-layout=RPM \
        --libdir=%{_libdir} \
        --sysconfdir=%{_sysconfdir}/httpd/conf \
        --includedir=%{_includedir}/httpd \
        --libexecdir=%{_libdir}/httpd/modules \
        --datadir=%{contentdir} \
        --with-installbuilddir=%{_libdir}/httpd/build \
        --enable-mpms-shared=all \
        --with-apr=%{_prefix} --with-apr-util=%{_prefix} \
        --enable-suexec --with-suexec \
        --with-suexec-caller=%{suexec_caller} \
        --with-suexec-docroot=%{contentdir} \
        --with-suexec-logfile=%{_localstatedir}/log/httpd/suexec.log \
        --with-suexec-bin=%{_sbindir}/suexec \
        --with-suexec-uidmin=500 --with-suexec-gidmin=100 \
        --enable-pie \
        --with-pcre \
        --enable-mods-shared=all \
        --enable-ssl --with-ssl --enable-socache-dc --enable-bucketeer \
        --enable-case-filter --enable-case-filter-in \
        --disable-imagemap \
        --with-included-apr \
        --with-included-apr-util \
        --with-included---with-pcre



cd /root/rpmbuild/SPECS
rpmbuild -ba httpd.spec



#########
1、卸载系统默认安装的http服务，apr
 rpm -qa| grep http
yum remove httpd
rpm -qa| grep apr
yum remove apr

2. 安装

yum install httpd-2.4.25-1.x86_64.rpm  httpd-devel-2.4.25-1.x86_64.rpm  httpd-tools-2.4.25-1.x86_64.rpm  apr-1.5.2-1.x86_64.rpm  apr-devel-1.5.2-1.x86_64.rpm apr-util-1.5.4-1.x86_64.rpm  apr-util-devel-1.5.4-1.x86_64.rpm