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

echo -e "${green} Install SSR ${plain}"
echo -e "${green} S1 Type: Default as SSR Python ${plain}"
echo -e "${green} S2 PWD: a_xx_9 ${plain}"
echo -e "${green} S3 Port: 14326 ${plain}"
echo -e "${green} S4 Encryption: Select 7 as aes-256-cfb ${plain}"

cd /root/ssr_result
./shadowsocks-all.sh 

echo -e "Your Server IP : ${red} scp root@$(get_ip):/root/ssr_result/shadowsocks_python_qr.png D:\H\Centos7\CentOS7\QRCodes\Vultr_$(get_ip).png ${plain}"

