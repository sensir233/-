#!/bin/bash

#获取Pictures文件夹下所有文件名
cd /home/yangyang/Pictures
rm -rf filename.txt
path=$1
files=$(ls $path)
for filename in $files
do
	echo $filename >> filename.txt
done

ftp -v -n 1.15.79.159<<EOF
user 1_15_79_159 Zy12345678
binary
hash
quote pasv
passive
prompt
cd /picture
mput *.jpg
put filename.txt
close
bye

