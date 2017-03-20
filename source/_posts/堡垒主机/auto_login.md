bash-3.2$ cat /usr/local/srsshd/bin/auto_login
#!/usr/bin/expect --
#version 3.1.7
set type [lindex $argv 0]
set os	 [lindex $argv 1]
set mode [lindex $argv 2]
set ip   [lindex $argv 3]
set port [lindex $argv 4]
set user [lindex $argv 5]
set pwd1 [binary format H* [lindex $argv 6]]
set pwd2 [binary format H* [lindex $argv 7]]

proc usage { } {
puts "\n"
puts {Usage:auto_login [protocol] [system] [console_mode] [ip] [port] [username] [hex_pwd1] [hex_pwd2]}
puts {protocol: [-t(elnet)] [-s(sh)]}
puts {system: [-l(inux/unix)] [-w(indows)] [-c(isco)] [-h(uawei)] [-n(etdevice)]}
puts {console_mode: [0(VT100 disabled)] [1(VT100 enabled)]}
puts "\n"
exit 0
}

#GLOBAL: check param
if { $type == "" || $os == "" || $mode == "" || $ip == "" || $port == "" || $user == "" } {
	puts	"<ERROR: argument illegal>"
	usage
	exit 1
}

set telnet "/usr/bin/telnet"
set ssh "/usr/bin/ssh"
set timeout 30
set keyfile ""
set string3 ""
set delay 1000

#GLOBAL: debugging...
#puts "type:$type"
#puts "os:$os"
#puts "mode:$mode"
#puts "ip:$ip"
#puts "port:$port"
#puts "user:$user"
#puts "pwd1:$pwd1"
#puts "pwd2:$pwd2"

#GLOBAL: while window resized
trap {
	set rows [stty rows]
	set cols [stty columns]
	stty rows $rows columns $cols < $spawn_out(slave,name)
} WINCH

#GLOBAL: prepare variables
switch --  $os \
	-l	{
		set user_pmt		"$ "
		set root_pmt		"# "
		set elevation_cmd	"su -"
	} -c {
		set user_pmt		">"
		set root_pmt		"#"
		set elevation_cmd	"en"
	} -h {
		set user_pmt		">"
		set root_pmt		"]"
		set elevation_cmd	"sys"
	} -w {
		set user_pmt		">"
		set root_pmt		">"
		set elevation_cmd	"\r"
	} -n {
		set user_pmt		">"
		set root_pmt		">"
		set elevation_cmd	"\r"
	} default {
		puts "<ERROR:unknown system>"
		usage
		exit 1
	}

set elevation_pmt			"assword:"
set pwd_pmt					"assword:"
set elevation_ok_pmt		$root_pmt
set login_pmt				"ogin:"
set login_fail_pmt			"failed"
set elevation_failed_pmt	"assword:"
set excmd		"0"

set empty_usr	"NULL-PASS"
set empty_pwd	"NULL-PASS"

proc handle_pwd { } {
	global pwd1 root_pmt pwd_pmt elevation_cmd elevation_pmt pwd2 user_pmt empty_usr empty_pwd os delay
	after $delay
	if { $pwd1 == "" || $pwd1 == $empty_pwd } return
	send -- "$pwd1\r"
	if { $pwd2 == "" } return
	expect	{
		eof			{ puts "<ERROR:EOF>"; exit 1 }
		timeout		{ puts "<INFO:TIMEOUT>"; exit 1}
		"$user_pmt"	{
			if { $os == "-l" } {
	            send -- "export LANG=en_US.UTF-8\r"
				send -- "export LANGUAGE=en_US.UTF-8\r"
			}
			send -- "$elevation_cmd\r"
			if { $pwd2 == $empty_pwd } return
			expect	{
				eof			{ puts "<ERROR:EOF>"; exit 1 }
				timeout		{ puts "<INFO:TIMEOUT>"; exit 1}
				"$elevation_pmt"	{
					send -- "$pwd2\r"
				}
				"$root_pmt"	return
			}
		}
		"$root_pmt" return
		"$pwd_pmt"  return
		"as:"		return
		"sername:"	return
	}
}

proc handle_user { } {
	global user pwd1 pwd_pmt empty_usr empty_pwd user_pmt root_pmt
	if { $user == $empty_usr }	return
	send -- "$user\r"
	if { $pwd1 == "" || $pwd1 == $empty_pwd }  return
	expect	{
		eof			{ puts "<ERROR:EOF>"; exit 1 }
		timeout		{ puts "<INFO:TIMEOUT>"; exit 1}
		"$pwd_pmt"	handle_pwd
		"$user_pmt"	return
		"$root_pmt" return
		"ogin:"		return
		"as:"		return
		"sername:"	return
	}
}

#get everything from database
if { $type == "-t" } {
	set fd [open "| /usr/local/bin/expectAssistant $ip $user 1" "r"]
} elseif { $type == "-s" } {
	set fd [open "| /usr/local/bin/expectAssistant $ip $user 0" "r"]
	set fd2 [open "| /usr/local/bin/sshkeyAssistant $ip $user 0 $port" "r"]
	gets $fd2 string3
	close $fd2
} else {
	puts "<ERROR:unknown protocol>"
	usage
	close $fd
	exit 1
}
gets $fd string2
close $fd

if { $string2 != "" } {
	set string [split $string2 "|"]
	set login_pmt				[binary format H* [lindex $string 0]	]
	set pwd_pmt					[binary format H* [lindex $string 1]	]
	set root_pmt				[binary format H* [lindex $string 2]	]
	set user_pmt				[binary format H* [lindex $string 3]	]
	set login_fail_pmt			[binary format H* [lindex $string 4]	]
	set elevation_cmd			[binary format H* [lindex $string 5]	]
	set elevation_pmt			[binary format H* [lindex $string 6]	]
	set elevation_ok_pmt 		[binary format H* [lindex $string 7]	]
	set elevation_failed_pmt	[binary format H* [lindex $string 8]	]
	set excmd					[binary format H* [lindex $string 14]	]
}

if { $os == "-l" } {

	if { $user_pmt == "$" } {
	    set user_pmt "\$ "
	}
	if { $root_pmt == "$" } {
	    set root_pmt "\$ "
	}

}

if { $string3 != "" } {
	set keyfile	[binary format H* $string3]
}


if { $type == "-t" } {
	if { $user == $empty_usr } {
		spawn -noecho $telnet -E $ip $port
		interact
		exit 0
	} else {
		spawn -noecho $telnet -E -l $user $ip $port
	}
} elseif { $type == "-s" } {
	if { $user == $empty_usr } {
#		puts "<ERROR: you must specify a username>"
#		usage
#		exit 1
		send_user -- "Plese Input Username: "
		expect_user -re "(.*)\n"
		send_user "\n"
		set username $expect_out(1,string)
		spawn -noecho $ssh -l $username -p $port $ip
	} else {
		if { $keyfile != "" } {
			#spawn -noecho chmod 600 $keyfile
			spawn -noecho $ssh -i $keyfile -l $user -p $port $ip
			interact
			exit 0
		} else {
			spawn -noecho $ssh -l $user -p $port $ip
		}
	}
} else {
	puts "<ERROR:unknown protocol>"
	usage
	exit 1
}

set excmd2 [scan $excmd "%d"]
set len1 [string length $excmd]
set len2 [string length $excmd2]
if { $len1 == $len2 && $len1 != "0" } {
    while { $excmd != "0" } {
        send -- "\r"
        set excmd [expr $excmd - 1]
    } 
}

expect {
	eof		{ puts "<ERROR:EOF>"; exit 1 }
	timeout	{ puts "<INFO:TIMEOUT>"; exit 1}
	"$pwd_pmt"	handle_pwd
	"name:"		handle_user
	"ogin:"		handle_user
	"as:"		handle_user
	"$login_pmt"	handle_user
}

if { $mode == "1" } {
	stty raw < $spawn_out(slave,name)
}
interact
exit 0

