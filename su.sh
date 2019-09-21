#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

shadowserver="0.0.0.0"
shadowsocksport=14326
shadowlocalip="127.0.0.1"
shadowlocalport="1080"
shadowtimeout=300
shadowsockscipher="aes-256-cfb"
shadowfastopen="false"

get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}

testfun(){
	echo -e "{\r" > config.json
	echo -e "    \"server\":\"${shadowserver}\",\r" >> config.json
	echo -e "    \"server_port\":${shadowsocksport},\r" >> config.json
	echo -e "    \"local_address\":\"${shadowlocalip}\",\r" >> config.json
	echo -e "    \"local_port\":${shadowlocalport},\r" >> config.json
	echo -e "    \"password\":\"aatkukb79\",\r" >> config.json
	echo -e "    \"timeout\":${shadowtimeout},\r" >> config.json
	echo -e "    \"method\":\"${shadowsockscipher}\",\r" >> config.json
	echo -e "    \"fast_open\":${shadowfastopen}\r" >> config.json
	echo -e "\r}\r" >> config.json
	cat config.json
	diff config.json config.bck.json
}

testfun
