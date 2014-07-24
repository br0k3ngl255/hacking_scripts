#!/bin/bash
#
#set -x
#created by br0k3ngl255
#date july 24 2014
####################################################################################################################################
#easy script to identify  the OS you are pentesting
#License : GPLv3
#Hack responsibly
#Disclamer -  I am not responsible for misuse of any of my scripts by others.
####################################################################################################################################
#interface='';
folder='/tmp';

while getopts ":i:f:" opt; do
    case $opt in
        i) interface="$OPTARG";;
        f) folder="$OPTARG";;
        *) echo "option requires an argument -- $OPTARG" >&2 ;;
    esac
                           done
##Funcs+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
checkTool(){
toolset=''
cmd=`dpkg -l |grep -v grep|grep xprobe 2>/dev/null &> /dev/null ; echo $?`
cmd2=`rpm -qa |grep -v grep|grep xprobe 2>/dev/null &> /dev/null ; echo $?`
instCMD=`apt-get install xprobe`
instCMD2=`yum install xprobe`
 if [ -f /etc/debian_version ] && [ -f /etc/os-release ];then
	if [ $cmd=="1" ];then
		$instCMD
	fi
elif [ -f /etc/redhat-release ];then
	if [ $cmd2=="1" ];then
		$instCMD2
	fi
else
	echo "not supported yet"
	exit
fi
toolset=$1
}
#Actions-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

if  [ "$interface" == "" ];then
	echo $interface
fi

checkTool
arp-scan -l -I $interface|grep -v grep |awk {'print $1'}|egrep [0-9]|while read line; do xprobe2 $line |grep Host|awk {'print $6 $7 $8 $9 $10'};done
