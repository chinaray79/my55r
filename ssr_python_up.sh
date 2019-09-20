#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
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

install_prepare_password(){
    echo "Please enter password for ${software[${selected}-1]}"
    read -p "(Default password: teddysun.com):" shadowsockspwd
    [ -z "${shadowsockspwd}" ] && shadowsockspwd="teddysun.com"
    echo
    echo "password = ${shadowsockspwd}"
    echo
}

get_parameters(){
	read -p "port (14326): " shadowsocksport
	[ -z "${shadowsocksport}" ] && shadowsocksport="14326"
	read -p "Password (a*9): " shadowsockspwd
	[ -z "${shadowsockspwd}" ] && shadowsockspwd="aatkukb79"
	read -p "Encryption (aes-256-cfb): " shadowsockscipher
	[ -z "${shadowsockscipher}" ] && shadowsockscipher="aes-256-cfb"
}

install_completed_python(){
    clear
    echo
    echo -e "Congratulations, ${green}${software[0]}${plain} server install completed!"
    echo -e "Your Server IP : ${red} $(get_ip) ${plain}"
    echo -e "Your Server Port : ${red} ${shadowsocksport} ${plain}"
    echo -e "Your Password : ${red} ***** ${plain}"
    echo -e "Your Encryption Method: ${red} ${shadowsockscipher} ${plain}"
}

qr_generate_python(){
	cur_dir=$( pwd )
    local tmp=$(echo -n "${shadowsockscipher}:${shadowsockspwd}@$(get_ip):${shadowsocksport}" | base64 -w0)
    local qr_code="ss://${tmp}"
    echo
    echo "Your QR Code: (For Shadowsocks Windows, OSX, Android and iOS clients)"
    echo -e "${green} ${qr_code} ${plain}"
    echo -n "${qr_code}" | qrencode -s8 -o ${cur_dir}/shadowsocks_python_qr.png
    echo "Your QR Code has been saved as a PNG file path:"
    echo -e "${green} ${cur_dir}/shadowsocks_python_qr.png ${plain}"
}

get_parameters
install_completed_python
qr_generate_python

