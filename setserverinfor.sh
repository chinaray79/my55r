#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}

default_server_infor="undefined"
get_server_infor(){
	echo -e "Please enter the server infor"
	read -p "Default Infor:${default_server_infor}:" server_infor
	[ -z "${server_infor}" ] && server_infor=${default_server_infor}
	echo ${server_infor}
}
write_server_infor(){
	    cat > server.json <<-EOF
{
    "server_infor":"${server_infor}",
    "server_ipaddr":$(get_ip)
}
EOF
}

get_server_infor
write_server_infor
cat server.json
