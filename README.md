# Remote-Plant-Farming-Developed-by-Raspberry-Pi
利用树莓派开发实现远程植物记录观看，监视植物状态
- 腾讯云轻量服务器
- 树莓派
- 摄像头
基本流程

![image](https://user-images.githubusercontent.com/94435405/214191812-9f9e1357-2d7c-4973-afd1-aa5df8dc628e.png)



##服务器端
我用的是腾讯云轻量云服务器，首先在服务器段


##树莓派
树莓派需要烧录官方镜像

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

chmod +x webcam.sh 使其具备可执行权限
利用crontab -e 为其设定定时执行周期

*/10 * * * * [脚本绝对路径] 2>&1

这样该脚本就会每隔10分钟执行一次，也就是每十分钟会为植物拍一张照
