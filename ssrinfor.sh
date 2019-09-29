#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
#/etc/shadowsocks-python/config.json
ss_cfig_file="/etc/shadowsocks-python/config.json"
ssr_cfig_file="/etc/shadowsocks.json"
server_cfig_file="server.json"
get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    echo ${IP}
}
# echo -n $1 | base64 -w0
code_base_64(){
	if [ $# -eq 1 ] ; then
		echo -n $1 | base64 -w0
	fi
}
get_json_value(){
	if [ $# -eq 2 ] ; then
		local val=$(cat $1 | grep $2)
		val=${val#*:}
		val=${val#*\"}
		val=${val%,*}
		val=${val%\"*}
		echo ${val}
	fi
}
get_ss_value(){
	if [ $# -eq 1 ] ; then
		echo $(get_json_value ${ss_cfig_file} $1)
	fi
}
get_ssr_value(){
	if [ $# -eq 1 ] ; then
		echo $(get_json_value ${ssr_cfig_file} $1)
	fi
}
get_server_value(){
	if [ $# -eq 1 ] ; then
		echo $(get_json_value ${server_cfig_file} $1)
	fi	
}
get_server_parameters(){
	server_group=$(get_server_value server_group)
	server_infor=$(get_server_value server_infor)
}
get_ss_parameters(){
	shadowserver=$(get_ss_value server\")
	shadowsocksport=$(get_ss_value server_port)
	shadowlocalip=$(get_ss_value local_address)
	shadowlocalport=$(get_ss_value local_port)
	shadowsockspwd=$(get_ss_value password)
	shadowtimeout=$(get_ss_value timeout)
	shadowsockscipher=$(get_ss_value method)
	fast_open=$(get_ss_value fast_open)
	server_infor=$(get_json_value server.json server_infor)
}


get_ssr_parameters(){
	get_server_parameters
	shadowserver_ip=$(get_ip)
	shadowserver_port=$(get_ssr_value server_port)
	shadowserver_protocol=$(get_ssr_value \"protocol\")
	shadowserver_method=$(get_ssr_value method)
	shadowserver_obfs=$(get_ssr_value \"obfs\")
	shadowserver_password=$(get_ssr_value password)
	shadowserver_obfsparam=$(get_ssr_value obfs_param)
	shadowserver_protocal_param=$(get_ssr_value protocol_param)
}
#ssr://server:port:protocol:method:obfs:password_base64/?params_base64
#params_base_64的构成为：
#   obfsparam=obfsparam_base64&protoparam=protoparam_base64&remarks=remarks_base64&group=group_base64
show_ssr_parameters(){
	echo "ip                 : ${shadowserver_ip}"
	echo "port               : ${shadowserver_port}"
	echo "pwd                : ${shadowserver_password}"
	echo "method(加密)       : ${shadowserver_method}"
	echo "protocal(协议)     : ${shadowserver_protocol}"
	echo "protocal_localparam: ${shadowserver_protocal_param}"
	echo "obfs(混淆)         : ${shadowserver_obfs}"
	echo "obfsparam(混淆参数): ${shadowserver_obfsparam}"
	echo "VPS Group          : ${server_group}"
	echo "VPS Remark         : ${server_infor}"

#	echo "ssr://NDUuMzIuMjMuNjc6MTEyNDk6YXV0aF9ha2FyaW5fcmFuZDpjaGFjaGEyMC1pZXRmOnRsczEuMl90aWNrZXRfYXV0aDpNRFpHUWsxU0lTcFFSSEpvVWpCNE1RPT0vP29iZnNwYXJhbT0="
#	echo "ssr://45.32.23.67:11249:auth_akarin_rand:chacha20-ietf:tls1.2_ticket_auth:MDZGQk1SISpQRHJoUjB4MQ==/?obfsparam="
#	echo "ssr://server:port:protocol:method:obfs:password_base64/?params_base64"
#	echo "  obfsparam=obfsparam_base64&protoparam=protoparam_base64&remarks=remarks_base64&group=group_base64"
}
calc_ssr_infors(){
	echo ""
	echo ""
	local ssrbasic="${shadowserver_ip}:${shadowserver_port}:${shadowserver_protocol}:${shadowserver_method}:${shadowserver_obfs}:$(code_base_64 ${shadowserver_password})"
	# $(code_base_64 ${})
	#local ssrparamas_base64="obfsparam=$(code_base_64 ${shadowserver_obfsparam})&protoparam=$(code_base_64 ${shadowserver_protocal_param})&remarks=$(code_base_64 ${server_infor})&group=$(code_base_64 ${server_group})"
	local ssrparamas_base64="obfsparam=$(code_base_64 ${shadowserver_obfsparam})&remarks=$(code_base_64 ${server_infor})&group=$(code_base_64 ${server_group})"
	# &remarks=$(code_base_64 ${server_infor})&group=$(code_base_64 ${server_group})
	local ssr_txt="${ssrbasic}/?${ssrparamas_base64}"
	echo "Before Base64 Coding:"
	echo "      ${ssr_txt}"
	echo ""
	echo -e "${green}ssr://$(code_base_64 ${ssr_txt})${plain}"
	echo ""
	echo ""
}
#旧的SS方式的处理方法
qr_generate_python(){
	cur_dir=$( pwd )
	local tmp_org="${shadowsockscipher}:${shadowsockspwd}@$(get_ip):${shadowsocksport}"
	#ss://method:password@server:port
	echo "QR Code Source is:"
	echo -e "ss://${tmp_org}"
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

if [  -f "${ss_cfig_file}" ];then
	get_ss_parameters
	qr_generate_python
	cp_funs
fi

if [  -f "${ssr_cfig_file}" ];then
	get_ssr_parameters
	#shadowserver_ip="45.32.23.67"
	show_ssr_parameters
	calc_ssr_infors
fi



#scp ray@192.168.12.211:/home/ray/ray/my55r/ssrinfor.sh D:/H/Centos7/CentOS7/ssrinfor.sh
#scp ray@192.168.12.211:/home/ray/ray/my55r/setserverinfor.sh D:/H/Centos7/CentOS7/setserverinfor.sh
