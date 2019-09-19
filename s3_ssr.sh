#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'


echo -e "${green} Install SSR ${plain}"
echo -e "${green} S1 Type: Default as SSR Python ${plain}"
echo -e "${green} S2 PWD: a_xx_9 ${plain}"
echo -e "${green} S3 Port: 14326 ${plain}"
echo -e "${green} S4 Encryption: Select 7 as aes-256-cfb ${plain}"

cd /root/ssr_result
./shadowsocks-all.sh 
