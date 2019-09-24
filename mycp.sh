#!/usr/bin/env bash
get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}
#scp  ray@192.168.12.211:/home/ray/ray/my55r/stmp.sh D:\H\Centos7\CentOS7\stmp.sh
#scp D:\H\Centos7\CentOS7\Step1_SSH.sh root@78.141.194.145:/root/s1_ssh.sh
function cptoserver(){
	if [ $# -eq 2 ];then
		echo scp $1 ray@$(get_ip):$2 
	fi
}
function cpfrserver(){
	if [ $# -eq 2 ];then
		echo scp  ray@$(get_ip):$1 $2 
	fi	
}

cptoserver /etc/shadowsocks.json Z:/shadowsocks.json
