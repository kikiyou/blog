---
title: 关闭VirtualBox Host与Guest之间的时间同步
date: 2016-08-18 16:10:02
tags: 
- virtual
---
# 关闭VirtualBox Host与Guest之间的时间同步
<!-- more -->
基本上，VirtualBox安装好后，Host OS与Guest OS之间，就会自动开启时间同步，也就是你在Host OS改了时间，Guest OS就会自动去更新成这个新的时间。但有些时刻，我们会想要让这两者之间的时间是不同步的，这时候就需要GetHostTimeDisabled这个功能出场了。


GetHostTimeDisabled这个变数并没有任何的GUI介面可以去设定，唯一可以处理的就是回归到VBoxManage.exe来运行。如果你没有将VBoxManage.exe设定成全域可运行的话，那麽请自行切换到VirtualBox预设目录去处理。接下来请大家打开cmd切到console模式吧！

列举你目前电脑下所有的VM Guest OS
``` bash
C:\Users\Administrator>VBoxManage list vms
"PC 000" {3c279b5b-7f47-4663-86ed-435e9e0dbba8}
"PC 001" {85eb55b3-7c6f-47d5-9273-42564c0ed795}
"PC 002" {e4e1de06-c508-4d71-93a3-d373ee9b9de7}
"PC 003" {4a9bf0d6-b7dc-4d97-ba85-9b65db7ec84b}
"PC 004" {7315c768-a353-4604-bb57-dbd5505724fc}
"PC 005" {7c96a6c8-c8ea-4fb6-8ced-fa8b55ff4be9}
"PC 006" {329bb2d9-1d07-4d8f-993e-fdae3bdf1d54}
```

对你想要禁止时间同步的Guest OS开刀
比对上例，假设我们想要对PC 006这一台电脑进行时间同步的禁止，那麽我们要下这样的指令：
``` bash
VBoxManage setextradata "PC 006" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" "1"
```
改完之后，如果没有任何的错误资讯，把Guest OS关机，然后Host OS也要重新开机，就完成了！如果有一天想要改回来，那也很简单，请使用下列的指令来解决即可。

VBoxManage setextradata "PC 006" "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled" "0"