#!/bin/bash
if [ -f /tmp/is_kernel_changed ]
then
(
 echo "10" ;sleep 1         
 echo "#正在应用更新...";sleep 1
 echo "20";sleep 1
 echo "50";sleep 1
 echo "75";sleep 1
 echo "99";sleep 1
 echo "#更新完毕,即将重启..."; sleep 2  
 echo "100";sleep 1
)|
zenity --progress --title="系统消息" --auto-close --text="应用更新内容" --percentage=0 --no-cancel --width=300 --height=100
reboot
fi
