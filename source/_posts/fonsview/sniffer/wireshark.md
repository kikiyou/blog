# wireshark 的使用

## 安装
1. dnf install wireshark

2. dnf install wireshark-gtk.x86_64 

3. 给用户赋予 权限
usermod -a -G wireshark monkey

4. 给抓取网卡的权限
setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/sbin/dumpcap


## 使用