#!/bin/bash
#我的文件结构
#/--www--wwwroot--IP地址--picture---------图片
#                         |                |
#                         |                filename.txt
#                         |
#                         index.html
#                         |
#                          update_html.sh

path="绝对路径"
src_x="2023-01-23_1500"
src_y="2023-01-23-1600"
src_x=$(grep './picture/' $path/index.html | awk -F/ '{print $3}' | awk -F. '{print $1}'|xargs)
src_y=$(sed -nr '/'"$src_x"'/{n;p}' $path/picture/filename.txt|awk -F. '{print $1}' |xargs )
sed -i 's/'"$src_x"'/'"$src_y"'/g' $path/index.html
