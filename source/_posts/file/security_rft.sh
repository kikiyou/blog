#! /bin/sh

##################### init  ######################
chattr -i /etc/passwd
chattr -i /etc/shadow
chattr -i /etc/group
chattr -i /etc/gshadow

chattr -R -i /bin /boot /lib /sbin
chattr -R -i /usr/bin /usr/include /usr/lib /usr/sbin
chattr -a /var/log/messages /var/log/secure /var/log/maillog

############### delete useless user ##############
userdel lp
groupdel lp

userdel news
groupdel news

userdel sync
groupdel sync

userdel shutdown
groupdel shutdown

userdel halt
groupdel halt
	
userdel uucp
groupdel uucp

userdel operator
groupdel operator

userdel games
groupdel games

userdel gopher
groupdel gopher

userdel fonsview
groupdel fonsview

userdel ftp

#################### crate user log ###########################
if [ ! -e '/var/log/pacct' ]; then
	touch /var/log/pacct 
	accton /var/log/pacct 
fi
#执行读取命令lastcomm [user name] –f /var/log/pacct 

################## stop service ###################
service  postfix stop
chkconfig postfix off

service nfslock stop
chkconfig nfslock off

service rpcbind stop
chkconfig rpcbind off

service httpd stop
chkconfig httpd off

################## lock useless user ##############
passwd -l listen
passwd -l gdm
passwd -l webservd
passwd -l nobody
passwd -l nobody4
passwd -l noaccess

################## change passwd length for warning ######
sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN    8/g' /etc/login.defs
#sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS    90/g' /etc/login.defs
#sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS    6/g' /etc/login.defs
#sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE    30/g' /etc/login.defs

###################################################
sed -i 's/auth.*pam_securetty.so/auth\trequired\tpam_securetty.so/g' /etc/pam.d/login

flag=`grep nospoof /etc/host.conf | wc -l`
if [ $flag -eq 0 ]; then
	echo "nospoof on" >> /etc/host.conf
fi

flag=`grep 'lcredit=-1' /etc/pam.d/system-auth | wc -l`
if [ $flag -eq 0 ]; then
	sed -i 's/pam_cracklib.so/pam_cracklib.so ucredit=-1 lcredit=-1 dcredit=-1 credit=-1/g' /etc/pam.d/system-auth
fi 

flag=`grep 'remember=5' /etc/pam.d/system-auth | wc -l`
if [ $flag -eq 0 ]; then
	sed -i 's/use_authtok/use_authtok remember=5/g' /etc/pam.d/system-auth
fi 

#flag=`grep 'pam_tally2.so' /etc/pam.d/system-auth | wc -l`
#if [ $flag -eq 0 ]; then
#	sed -i '/auth/{s/$/\nauth required pam_tally2.so deny=5 unlock_time=600 no_lock_time/;:f;n;b f;}' /etc/pam.d/system-auth
#	sed -i '/account/{s/$/\naccount required pam_tally2.so/;:f;n;b f;}' /etc/pam.d/system-auth
#fi 

######################################################
flag=`grep 'bin:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/bin:\*/bin:!!/g' /etc/shadow
fi

flag=`grep 'daemon:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/daemon:\*/daemon:!!/g' /etc/shadow
fi

flag=`grep 'adm:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/adm:\*/adm:!!/g' /etc/shadow
fi

flag=`grep 'lp:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/lp:\*/lp:!!/g' /etc/shadow
fi

flag=`grep 'sync:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/sync:\*/sync:!!/g' /etc/shadow
fi

flag=`grep 'shutdown:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/shutdown:\*/shutdown:!!/g' /etc/shadow
fi

flag=`grep 'halt:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/halt:\*/halt:!!/g' /etc/shadow
fi

flag=`grep 'mail:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/mail:\*/mail:!!/g' /etc/shadow
fi

flag=`grep 'uucp:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/uucp:\*/uucp:!!/g' /etc/shadow
fi

flag=`grep 'operator:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/operator:\*/operator:!!/g' /etc/shadow
fi

flag=`grep 'games:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/games:\*/games:!!/g' /etc/shadow
fi

flag=`grep 'gopher:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/gopher:\*/gopher:!!/g' /etc/shadow
fi

flag=`grep 'nobody:*' /etc/shadow | wc -l`
if [ $flag -ne 0 ]; then
	sed -i 's/nobody:\*/nobody:!!/g' /etc/shadow
fi
####################unlock fonsview#######################
pam_tally2 -r -u fonsview

####################################################
awk '{if($2=="required")sub(/#auth/, "auth")sub(/use_uid/, "group=wheel")};1' /etc/pam.d/su 1<>/etc/pam.d/su

###################### add user ###################
user="fonsview"
passwd="monkeyLoveYou"

suPasswd="hello123"

echo ${suPasswd} | passwd --stdin root

flag=`grep ${user} /etc/passwd | wc -l`
if [ $flag -eq 0 ]; then
	useradd ${user}
	echo ${passwd} | passwd --stdin ${user}
	usermod -G wheel ${user}
	groups ${user}
else
	usermod -G wheel ${user}
	groups ${user}
fi

#################### rsyslog ########################
#flag=`grep '^*\.\*' /etc/rsyslog.conf | wc -l`
#if [ $flag -eq 0 ]; then
#        echo '*.* @222.68.211.84' >> /etc/rsyslog.conf
#fi

##################### add grub passwd ################
flag=`grep password /boot/grub/grub.conf | wc -l`
if [ $flag -eq 0 ]; then
	cp /boot/grub/grub.conf /tmp/grub.conf.bak
	sed -i 's/hiddenmenu/hiddenmenu\npassword --md5 $1$cVIcK1$pXOVhaAEzQ85QEccTnjRg0/g' /boot/grub/grub.conf 
fi

################# restrict remote login ##############
flag=`grep "^PermitRootLogin no" /etc/ssh/sshd_config | wc -l`
if [ $flag -eq 0 ]; then
	cp /etc/ssh/sshd_config /tmp/sshd_config.bak
	sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config 
	service sshd restart
fi

############### root no input timeout ################
#flag=`grep "HISTSIZE=1000" /etc/profile | wc -l`
#if [ $flag -ne 0 ]; then
#	cp /etc/profile /tmp/profile.bak
#	sed -i 's/TMOUT.*//g' /etc/profile 
#	sed -i 's/HISTSIZE=1000/HISTSIZE=5\nHISTFILESIZE=5\nexport TMOUT=300/g' /etc/profile 
#fi

####################### change sysctl ######################
function change_sysctl()
{
        key=${1}
        result=${2}
        conf_file='/etc/sysctl.conf'

        value=`sysctl -a | grep $key | awk '{print $NF}'`
        if [ $value -ne $result ];then
                flag=`grep ${key} ${conf_file} | wc -l`
                if [ $flag -eq 0 ];then
                        echo "${key} = $result" >> ${conf_file}
                else
                        sed -i "s/${key}.*/${key} = $result/g" ${conf_file}
                fi

                proc="/proc/sys/"`echo ${key} | sed -e 's/\./\//g'`
                echo ${proc}
                sysctl -w ${key}="$result"
                echo $result > ${proc}
        fi
}

change_sysctl 'net.ipv4.conf.all.accept_source_route' 0
change_sysctl 'net.ipv4.conf.all.accept_redirects' 0
change_sysctl 'net.ipv4.conf.all.send_redirects' 0
change_sysctl 'net.ipv4.ip_forward' 0
change_sysctl 'net.ipv4.icmp_echo_ignore_broadcasts' 1

############## vsftpd disable anonymous #################
flag=`grep "anonymous_enable=NO" /etc/vsftpd/vsftpd.conf | wc -l`
if [ $flag -eq 0 ]; then
	cp /etc/vsftpd/vsftpd.conf /tmp/vsftpd.conf.bak
	sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf 
fi

################ detele console apps ####################
#rm -f /etc/security/console.apps/*

########################################################
flag=`grep "err;kern.debug;daemon.notice" /etc/rsyslog.conf  | wc -l`
if [ $flag -eq 0 ]; then
	echo '*.err;kern.debug;daemon.notice /var/adm/messages' >> /etc/rsyslog.conf
	service rsyslog restart
	touch /var/adm/messages
	chmod 666 /var/adm/messages
fi

################ change umask ############################
sed -i 's/umask .*/umask 077/g' /etc/profile
sed -i 's/umask .*/umask 077/g' /etc/csh.cshrc
sed -i 's/umask .*/umask 077/g' /etc/bashrc

flag=`grep 'UMASK' /etc/login.defs | wc -l`
if [ $flag -eq 0 ]; then
	echo 'UMASK 027' >> /etc/login.defs
else
	sed -i 's/UMASK .*/UMASK 027/g' /etc/login.defs
fi

###########################################
flag=`grep 'hard core' /etc/security/limits.conf | wc -l`
if [ $flag -eq 0 ]; then
	echo '* hard core 0' >> /etc/security/limits.conf
fi

#awk '{if($1=="#\*" && $2=="hard" && $3=="core")sub(/#\*/,"*")};1' /etc/security/limits.conf
awk '{if($2=="soft")sub(/#\*/,"*")};1' /etc/security/limits.conf 1<>/etc/security/limits.conf

##############################################
#flag=`grep pam_tally2.so /etc/pam.d/sshd | wc -l`
#if [ $flag -eq 0 ]; then
#	sed -i '/auth/{s/$/\nauth required pam_tally2.so deny=5 unlock_time=600 no_lock_time/;:f;n;b f;}' /etc/pam.d/sshd
#	sed -i '/account/{s/$/\naccount required pam_tally2.so/;:f;n;b f;}' /etc/pam.d/sshd
#fi

###############################################
chmod 400 /etc/cron.monthly
chmod 644 /var/log/messages
chmod 660 /var/log/wtmp
# 750 /etc will not use scp、ifconfig etc command. for Shanghai telecom 
#chmod 750 /etc/
chmod 750 /etc/ssh
chmod 600 /etc/hosts.deny
chmod -R 751 /var/log
chmod 400 /etc/cron.d
chmod 600 /etc/hosts.allow
chmod -R 750 /etc/pam.d
chmod -R 750 /etc/rc.d/init.d/
#chmod 750 /etc/rc?.d
chmod -R 751 /etc/sysconfig
chmod 400 /etc/cron.hourly
chmod 700 /bin/rpm
chmod 640 /var/log/lastlog
chmod 600 /etc/exports
chmod 600 /etc/security
chmod 400 /etc/cron.daily
chmod 600 /etc/crontab
chmod 600 /boot/grub/grub.conf


#################################################
file=`find /usr/bin/chage /usr/bin/gpasswd /usr/bin/wall /usr/bin/chfn /usr/bin/chsh /usr/bin/newgrp /usr/bin/write /usr/sbin/usernetctl /usr/sbin/traceroute /bin/mount /bin/umount /bin/ping /sbin/netreport -type f -perm +6000 2>/dev/null`

for f in $file; do
	chmod 755 $f
	ls -l $f
done

################################################
LOGDIR=`cat /etc/rsyslog.conf | grep -v "^[[:space:]]*#" |sed '/^#/d' |sed '/^$/d' |awk '(($2!~/@/) && ($2!~/*/) && ($2!~/-/)) {print $2}'`;
file=`ls $LOGDIR 2>/etc/null`
for f in $file; do
        chmod 640 $f
done

LOGDIR=`cat /etc/rsyslog.conf | grep -v "^[[:space:]]*#" |sed '/^#/d' |sed '/^$/d' |awk '(($2!~/@/) && ($2!~/*/) && ($2!~/-/)) {print $2}'`;ls -l $LOGDIR 2>/etc/null | grep "^-";

################################################
gconftool-2 --direct --config-source xml:readwrite:/etc/gconf/gconf.xml.mandatory --type string --set /apps/gnome-screensaver/mode blank-only

echo "Login success. All activity will be monitored and reported " > /etc/motd


###################### for mail ##################
sed -i 's/^games/#games/g' /etc/aliases
sed -i 's/^ingres/#ingres/g' /etc/aliases
sed -i 's/^system/#system/g' /etc/aliases
sed -i 's/^toor/#toor/g' /etc/aliases
sed -i 's/^uucp/#uucp/g' /etc/aliases
sed -i 's/^manager/#manager/g' /etc/aliases
sed -i 's/^dumper/#dumper/g' /etc/aliases
sed -i 's/^operator/#operator/g' /etc/aliases
sed -i 's/^decode/#decode/g' /etc/aliases
sed -i 's/^root/#root/g' /etc/aliases
/usr/bin/newaliases

################ increase the permissions #############
chmod 644 /etc/passwd*
chmod 400 /etc/shadow*
chmod 644 /etc/group*

###################### Banner ######################
mv /etc/issue.net  /etc/issue.net.bak
mv /etc/issue /etc/issue.bak

##################### change sshd port 49721 ################
flag=`grep "Port 49721" /etc/ssh/sshd_config | wc -l`
if [ $flag -eq 0 ]; then
	cp /etc/ssh/sshd_config /tmp/sshd_config.bak
	sed -i 's/#Port.*/Port 49721/g' /etc/ssh/sshd_config
	sed -i 's/^Port.*/Port 49721/g' /etc/ssh/sshd_config
	service sshd restart
fi
##################### change sshd root close ################
flag=`grep "PermitRootLogin" /etc/ssh/sshd_config | wc -l`
if [ $flag -eq 0 ]; then
	cp /etc/ssh/sshd_config /tmp/sshd_config.bak
	sed -i 's/#PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
	sed -i 's/^PermitRootLogin.*/PermitRootLogin no/g' /etc/ssh/sshd_config
	service sshd restart
fi


################## change mysql #####################
awk -F':' '{if($1=="mysql")sub(/bash/,"false");}1' /etc/passwd 1<>/etc/passwd

file="t.sql"
echo "drop database test;" > ${file}
echo "DELETE from mysql.db WHERE Db='test' OR Db='test\_%';" >> ${file}
echo "flush privileges;" >> ${file}
mysql < ${file}
rm -f ${file}

flag=`grep set-variable=local-infile /etc/my.cnf | wc -l`
if [ $flag -eq 0 ]; then
	echo "set-variable=local-infile=0" >> /etc/my.cnf
fi

sed -i 's/max_connections.*/max_connections=1000/g' /etc/my.cnf

chown -R mysql.mysql /var/lib/mysql
chmod -R go-rwx /var/lib/mysql 
mysqladmin -uroot password 'xxxxx'

#service mysql restart

################ readonly #######################
chmod -R go-w /etc
chmod -R 750 /etc/rc.d/init.d/*

#chattr +i /etc/passwd
#chattr +i /etc/shadow
#chattr +i /etc/group
#chattr +i /etc/gshadow

#chattr -R +i /bin /boot /lib /sbin
#chattr -R +i /usr/bin /usr/include /usr/lib /usr/sbin
#chattr +a /var/log/messages /var/log/secure /var/log/maillog

###############################################
service ntpd start

rm -f $0
