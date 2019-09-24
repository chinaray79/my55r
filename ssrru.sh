#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

if [ ! -d "/root/ssr_result" ];then
	echo "the folder exists"
	cd /root/ssr_result
	./shadowsocks-all.sh uninstall
	cd /root
	mv ssr_result ssr_result_old
	yum -y install curl
	bash -c "$(curl -fsSL https://git.io/fNpuL)"
fi
