#!/bin/bash
src_x="2023-01-23_1500"
src_y="2023-01-23-1600"
src_x=$(grep './picture/' index.html | awk -F/ '{print $3}' | awk -F. '{print $1}'|xargs)
src_y=$(sed -nr '/'"$src_x"'/{n;p}' ./picture/filename.txt|awk -F. '{print $1}' |xargs )
sed -i 's/'"$src_x"'/'"$src_y"'/g' index.html
