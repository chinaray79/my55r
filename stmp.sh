#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

shadowserver="0.0.0.0"
shadowsocksport=50505
shadowoldport=14326
shadowlocalip="127.0.0.1"
shadowlocalport="1080"
shadowsockspwd="aatkukb79"
shadowtimeout=300
shadowsockscipher="aes-256-cfb"
fast_open="false"

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
