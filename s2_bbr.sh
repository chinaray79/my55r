#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

echo -e "${green} Prepare To Install BBR ${plain}"
echo -e "${green} It will request restart when finished ${plain}"
cd /root/ssr_result
./bbr.sh

