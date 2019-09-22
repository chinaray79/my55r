#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
#/etc/shadowsocks-python/config.json
ssr_cfig_file="/etc/shadowsocks-python/config.json"

get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}
get_json_value(){
	if [ $# -eq 2 ] ; then
		local val=$(cat $1 | grep $2)
		val=${val#*:}
		val=${val%*,}
		echo ${val}
	fi
}
get_ssr_value(){
	if [ $# -eq 1 ] ; then
		echo $(get_json_value ${ssr_cfig_file} $1)
	fi
}
get_ssr_parameters(){
	shadowserver=$(get_ssr_value server\")
	shadowsocksport=$(get_ssr_value server_port)
	shadowlocalip=$(get_ssr_value local_address)
	shadowlocalport=$(get_ssr_value local_port)
	shadowsockspwd=$(get_ssr_value password)
	shadowtimeout=$(get_ssr_value timeout)
	shadowsockscipher=$(get_ssr_value method)
	fast_open=$(get_ssr_value fast_open)
	server_infor=$(get_ssr_value server.json server_infor)
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
	echo -e "${red}--------------------------------------------------------------------------"
	echo ""
	echo -e "${green}scp root@$(get_ip):/root/ssr_$(get_ip).txt D:\\SSR\\SSR_$(get_ip).txt\r"
	echo -e "${green}scp root@$(get_ip):/root/shadowsocks_python_qr.png D:\\SSR\\SSR_$(get_ip).png\r"
	echo -e "${green}echo %date% %time%  The SSR For IP:$(get_ip) Port:${shadowsocksport} Server:${server_infor}>> D:\\SSR\\SSR_Result.txt"
	echo -e "${green}more D:\\SSR\\ssr_$(get_ip).txt >> D:\\SSR\\SSR_Result.txt${plain}"
	echo -e "${green}echo. >> D:\\SSR\\SSR_Result.txt${plain}"
	echo -e "${green}echo. >> D:\\SSR\\SSR_Result.txt${plain}"
	echo ""
	echo ""
	echo ""
}
get_ssr_parameters
qr_generate_python
cp_funs
