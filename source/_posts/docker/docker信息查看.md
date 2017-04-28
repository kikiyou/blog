docker info   查看docker相关信息

root@monkey:~/docker_work# docker login 172.16.18.5:30088
Username (admin): admin
Password: 
Login Succeeded


登录成功的证明：
root@monkey:~/docker_work# cat ~/.docker/config.json
{
	"auths": {
		"172.16.18.5:30088": {
			"auth": "YWRtaW46aGVsbG8xMjM="
		}
	}
}#                                                                                                                                                                           
root@monkey:~/docker_work# 



-----------------
root ➜  ~ docker login 172.16.18.5:30088
Username (admin): monkey
Password: 
Error response from daemon: Login: <html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.11.5</center>
</body>
</html>
 (Code: 404; Headers: map[Date:[Thu, 27 Apr 2017 12:13:40 GMT] Content-Type:[text/html] Content-Length:[169] Server:[nginx/1.11.5]])
root ➜  ~ 
root ➜  ~ docker login 172.16.18.5:30088
Username (admin): monkey
Password: 
Error response from daemon: Get http://172.16.18.5:30088/v2/: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)
root ➜  ~ docker login 172.16.18.5:30088
Username (admin): monkey
Password: 
Login Succeeded
