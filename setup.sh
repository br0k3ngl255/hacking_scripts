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
########################################################################################################

###Variables~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Bin-files
sslstripV2='/usr/local/bin/sslstrip'
dns2Proxy='/opt/dns2proxy'



function verifyPoint(){
touch /usr/share/backgrounds/file.txt
	echo 1 > /usr/share/backgrounds/file.txt
}


function firstRun(){
if [ `cat /usr/share/backgrounds/file.txt`=="0" ];then
	
	checkTools
		checkEttercapConfig
}
function checkTools(){
if [[ ! -f $sslstripV2 ] && [ ! -f $dns2Proxy ]];then
mkdir -p /tmp/sslV2 -m 777
	cd /tmp/sslV2
	wget http://www.dnspython.org/kits/1.11.1/dnspython-1.11.1.tar.gz;sleep 1
	tar xvzf dnspython-1.11.1.tar.gz;cd dnspython-1.11.1; python setup.py install
	wget https://github.com/LeonardoNve/sslstrip2/archive/master.zip
	unzip master.zip; cd sslstrip2-master;python setup.py install
	wget https://github.com/LeonardoNve/dns2proxy/archive/master.zip
	unzip master.zip;cd dns2proxy-master
fi
}
function checkEttercapConfig (){
	comd=`cat etterConf |grep ec_uid\ =\ 65534;echo $?`
	comd1=`cat etterConf2 |grep ec_uid\ =\ 65534;echo $?`
	comd2=`cat etterConf |grep ec_gid\ =\ 65534;echo $?`
	comd3=`cat etterConf2 |grep ec_gid\ =\ 65534;echo $?`
	comd4=`cat etterConf |grep redir_command|egrep iptables`
	comd5=`cat etterConf2 |grep redir_command|egrep iptables`
if [ `comd` == "0" ] && [ `comd1 ` == "0" ] && [ `comd2 ` == "0" ] && [ `comd3` == "0" ] ;then
	sed -i -e s/ 65534/0/g /etc/ettercap/etter.conf
	sed -i -e s/ 65534/0/g /etc/etter.conf

	if [ `comd4` == "0" ] && [ `comd5` == "0" ];then
		sed -i -e s/#redir_command_on/redir_comma/nd_on/g /etc/etter.conf
		sed -i -e s/#redir_command_off/redir_command_off/g /etc/etter.conf
	fi
else
	echo "Configured"
fi
}


