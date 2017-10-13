安徽联通双电源异常
ok: [ZX-SS3] => {
    "result.stdout": "1"
}
ok: [LA-SS1] => {
    "result.stdout": "1"
}


1.当前tcp连接数
node_netstat_Tcp_CurrEstab 21


总流量：
sum(irate(node_network_receive_bytes{device=~"^eth[0-9]$",group="省中心点",instance="ZX-SS2:39100",job="node"}[5m]))

主机网卡bond状态
node_bonding_active{master="bond0"} 2


磁盘可用率：
node_filesystem_avail{mountpoint="/"} / node_filesystem_size{mountpoint="/"} * 100