#!/usr/bin/env bash 
set -x 
#created by br0k3ngl@55

########################################################################################################
#purpose:
#	create one script to automate new way of sslstrip created by Leonardo Nve with dns2Proxy script
#License: automate
#notice: by this, i would like to notify that any use of this script not for studying purposes
# is a violation of law. Please validate your local law. By this i'd like take off any responsibly
# of myself.
# please hack responsibly. 
#######################################################################################################


function killdns2proxy() {

cmd=$(ps aux |grep dns2proxy.py|grep -v grep|awk '{print $2}'|head -1 >/tmp/var;echo $?)
killVar=$(cat /tmp/var)
if [ $cmd == "0" ];then

kill -9 $killVar
fi 
}

killall ettercap
killall sslstrip
killdns2proxy
