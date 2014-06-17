#!/bin/bash 
#
#created by br0k3ngl255
#date :06.17.2013
#
##################################################################################
#License GPL_v3
#purpose : 
# tired of manully patching the kernel, i tryed to automate this process as much as
#possible, i won't need to do it again.
##################################################################################

###+++++++++++++Variables++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SRC='/usr/src/'
KRNL=''
###------------Functions---------------------------------------------------------
function verifyTools(){
list=('build-essential ''libncurses5-dev ''zlib1g-dev ''gawk'' git'' ccache'' gettext ''libssl-dev ''xsltpro'  'make' 'aircrack-ng' 'patch')
pcCmd=$(dpkg -l |grep $program > /dev/null ;echo $?)
for program in ${list[*]}
	do
		if [ $pcCmd != "0" ];then
			apt-get install $program
		fi
	done
}

function kernelCheck(){
cmd=$(uname -r)
checkKRNL=$(wget https://www.kernel.org/pub/linux/kernel/projects/backports/stable//backports-$cmd.tar.bz2 2> /dev/null 1> /dev/null & |grep 404; echo $?)
if [ `checkKRNL` == "1" ];then
	echo "try downloading manually the kernel and patch it."
	exit
elif [ `checkKRNL`== "0" ];then
#need to figure out to to check kernel that needs to be patched.

	
fi
}


###-_-_-_-_-_-_Actions-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
if [ $# == 0 ];then
verifyTools
	kernelCheck

fi
