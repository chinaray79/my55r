#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

#used port(65535 Max) 14326.  

shadowserver="0.0.0.0"
shadowsocksport=50505
shadowoldport=14326
shadowlocalip="127.0.0.1"
shadowlocalport="1080"
shadowsockspwd="aatkukb79"
shadowtimeout=300
shadowsockscipher="aes-256-cfb"
fast_open="false"


get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}

set_ssr_json(){
	read -p "port (50505): " shadowsocksport
	[ -z "${shadowsocksport}" ] && shadowsocksport="50505"

	cat > ${shadowsocks_python_config}<<-EOF
{
    "server":"0.0.0.0",
    "server_port":${shadowsocksport},
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${shadowsockspwd}",
    "timeout":300,
    "method":"${shadowsockscipher}",
    "fast_open":${fast_open}
}
EOF
	echo -e "${green}if the file exists,please ${red}do not overwrite ${green}the file${plain}"
	cp /etc/shadowsocks-python/config.json /etc/shadowsocks-python/config.${shadowoldport}.json
	cp config.json /etc/shadowsocks-python/config.json
}
qr_generate_python(){
	cur_dir=$( pwd )
    local tmp=$(echo -n "${shadowsockscipher}:${shadowsockspwd}@$(get_ip):${shadowsocksport}" | base64 -w0)
    local qr_code="ss://${tmp}"
    echo
    echo "Your QR Code: (For Shadowsocks Windows, OSX, Android and iOS clients)"
    echo -e "${green} ${qr_code} ${plain}"
	echo "${qr_code}" > ssr_$(get_ip).txt
    echo -n "${qr_code}" | qrencode -s8 -o ${cur_dir}/shadowsocks_python_qr.png
    echo "Your QR Code has been saved as a PNG file path:"
    echo -e "${green} ${cur_dir}/shadowsocks_python_qr.png ${plain}"
}
cp_funs(){
	echo ""
	echo ""
	echo "${red}--------------------------------------------------------------------------"
	echo ""
	echo -e "${green}scp root@$(get_ip):/root/ssr_$(get_ip).txt D:\\SSR\\SSR_$(get_ip).txt\r"
	echo -e "${green}scp root@$(get_ip):/root/shadowsocks_python_qr.png D:\\SSR\\SSR_$(get_ip).png\r"
	echo -e "${green}echo %date% %time%  The SSR For IP:$(get_ip) Port:${shadowsocksport} >> D:\\SSR\\SSR_Result.txt"
	echo -e "${green}more D:\\SSR\\ssr_$(get_ip).txt >> D:\\SSR\\SSR_Result.txt${plain}"
	echo -e "${green}echo. >> D:\\SSR\\SSR_Result.txt${plain}"
	echo -e "${green}echo. >> D:\\SSR\\SSR_Result.txt${plain}"
	echo ""
	echo ""
	echo ""
}

####################################################
# Useless function: 
####################################################
get_parameters(){
	read -p "port (50505): " shadowsocksport
	[ -z "${shadowsocksport}" ] && shadowsocksport="50505"
	read -p "Password (a*9): " shadowsockspwd
	[ -z "${shadowsockspwd}" ] && shadowsockspwd="aatkukb79"
	read -p "Encryption (aes-256-cfb): " shadowsockscipher
	[ -z "${shadowsockscipher}" ] && shadowsockscipher="aes-256-cfb"
}

set_ssr_json
qr_generate_python
cp_funs
/etc/init.d/shadowsocks-python restart
