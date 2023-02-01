# 云养植
# Remote-Plant-Farming-Developed-by-Raspberry-Pi
利用树莓派开发实现远程植物记录观看，通过html监视植物状态
- 腾讯云轻量服务器(centos7)
- 树莓派（raspberrypi 4B）
- 摄像头(usb网络摄像头)
基本流程

![image](https://user-images.githubusercontent.com/94435405/214191812-9f9e1357-2d7c-4973-afd1-aa5df8dc628e.png)

## 演示 
![image](https://user-images.githubusercontent.com/94435405/214192267-988427a1-a90d-4bf6-be68-d4bb2b04dbfe.png)

由于懒得添加域名这里为了安全起见就不给大家展示网站了

## 服务器端
我用的是腾讯云轻量云服务器，选用了开发难度较低的ftp与树莓派进行通讯
### 安装宝塔
yum install -y wget && wget -O install.sh https://download.bt.cn/install/install_6.0.sh && sh install.sh 12f2c1d72

### 安装ftp

在宝塔界面直接建立网站勾选ftp可直接建立。

### html编写

选用的基本的index.html更换了图片路径后期会加入css和js，本人对于前端设计为新手级别，所以设计的丑陋还请海量。

### 脚本定时更新html图片路径

这里我创建了一个脚本update_pic.sh
```
#!/bin/bash
src_x="2023-01-23_1500"
src_y="2023-01-23-1600"
src_x=$(grep './picture/' index.html | awk -F/ '{print $3}' | awk -F. '{print $1}'|xargs)
src_y=$(sed -nr '/'"$src_x"'/{n;p}' ./picture/filename.txt|awk -F. '{print $1}' |xargs )
sed -i 's/'"$src_x"'/'"$src_y"'/g' index.html
```

## 树莓派
树莓派需要烧录官方镜像
### 定时拍照任务
使用usv网络摄像头
首先要用sudo raspi-config进入树莓派配置界面

![image](https://user-images.githubusercontent.com/94435405/214190578-114e312a-6827-478c-9ebd-9b22a0b73a98.png)

进入interface Options

点击Legacy Camera

![image](https://user-images.githubusercontent.com/94435405/214191144-4e59cf87-047f-4965-9445-d12f1d9aed27.png)

确定配置为enable

![image](https://user-images.githubusercontent.com/94435405/214191201-86a125a0-5aaa-4ee3-a7be-1c97e3d022d9.png)


采用fswebcam捕捉植物照片，创建脚本文件webcam.sh
fswebcam --no-banner -r 640x480 [文件存储路径]

文件命名为 %Y-%m-%d_%H%M

树莓派时区设置为亚洲-上海

chmod +x webcam.sh 使其具备可执行权限
利用crontab -e 为其设定定时执行周期

*/10 * * * * [脚本绝对路径] 2>&1

这样该脚本就会每隔10分钟执行一次，也就是每十分钟会为植物拍一张照

### ftp上传并添加至任务
我创建了ftp上传脚本 ftp_login.sh
```
ftp -v -n [你的ftpIP地址]<<EOF                           
user  [IP地址] [ftp登录密码]                          
binary                          
hash                           
quote pasv #这两步是为了让ftp客户端进入被动模式，片面的解决了树莓派客户端无法访问ftp服务端的问题                          
passive    #                           
prompt                         
cd /picture                         
mput *.jpg                        
put filename.txt                         
close                          
bye
```
### 防存储溢出的定时保护
这里就是很简单的周期对pictures文件夹使用用rm -rf，这样虽有不妥但目前先这样用着后期再寻找更好更安全的方式
                        
# 2023-01-29更新加入新的文件上传机制并在轻量服务器加入mysql数据库管理图片路径

由于linux系统单个目录下文件容纳数是有限制的，因此树莓派获得n张图片后需要将创建新的目录来容纳新的图片，同时为了加快上传速度，应该将原来文件夹进行打包上传，同时为了方便图片管理需要加入新的图片管理脚本
 
# proftp上传文件数量有限制
可以通过修改.conf文件来增大最大文件数量，但是我觉得和该系统本身的逻辑有关系，我一次是将全部文件进行覆盖刷新，并且传递所有已获得的图片这也就导致非常浪费带宽和内存。
