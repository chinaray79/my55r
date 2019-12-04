#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

echo -e "${green} Set Time Zone ${plain}"
date -R 
timedatectl set-timezone Asia/Shanghai
date -R 

cd /etc/ssh
grep ClientAlive sshd_config
echo -e "${green} backup sshd_config ${plain}"
cp sshd_config sshd_config_ray.bak
echo -e "${green} using sed to modify the file ${plain}"
sed -i "s/#ClientAliveInterval 0/ClientAliveInterval 60/g" sshd_config
sed -i "s/#ClientAliveCountMax 3/ClientAliveCountMax 50/g" sshd_config

grep ClientAlive sshd_config
echo -e "${green} using diff to compare ${plain}"
diff sshd_config sshd_config_ray.bak
echo -e "${green} reloading ssh ${plain}"
service sshd reload
echo -e "${green} checking the ssh position ${plain}"
grep AuthorizedKeysFile /etc/ssh/sshd_config
echo -e "${green}  go to home ${plain}"

cd ~
echo -e "${green} create id_rsa_pub ${plain}"
rm -r .ssh
mkdir .ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2L1bjX413OrMCjNN112xrFeT8QvrOpJopUI96A/s/lszQHd+N4rlOm20bhJc9WDsbKTnpWLax9y3rxuL6KFTvH4tY0QNwbNAE9N9pdAPHYAviQ/ElXtjoKDql6uoe/uowzyPPmsV36hnFyHeb9Sehk/bZI81wrKVnXNIqWLqALk7b6FpUdcLDoaqwfAJ842AN+SI2Ks0i/Q+PnuvsoY2QXIi9P80SoaIf6Fg+0I0AOy6tJerPLOAvWe0PQGxjSmyAY+LF7lFVp4rsb7ESP8Fp8A0nXT5hgR5s0ZGZDxZMj0MlT//xZL3PNLOewDIIplNwQ0Dl9xqCt6bLE9mnc+3J Ray@RayMiPro" > .ssh/id_rsa.pub
echo "">> .ssh/id_rsa.pub
cat .ssh/id_rsa.pub
echo -e "${green} set /etc/dropbear/authorized_keys ${plain}"
cat .ssh/id_rsa.pub > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys

echo -e "${green} update system ${plain}"
yum clean all
yum -y update
echo -e "${green} Install WGet ${plain}"
yum -y install wget


echo -e "${green} Prepare Files ${plain}"
mkdir -p /root/ssr_result
cd /root/ssr_result
wget ¨Cno-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh 
chmod +x bbr.sh 

wget ¨Cno-check-certificate -O shadowsocks-all.sh https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocks-all.sh
chmod +x shadowsocks-all.sh

yum install -y unzip
yum install -y gzip
yum install -y openssl
yum install -y openssl-devel
yum install -y gcc
yum install -y python
yum install -y python-devel
yum install -y python-setuptools
yum install -y pcre
yum install -y pcre-devel
yum install -y libtool
yum install -y libevent
yum install -y autoconf
yum install -y automake
yum install -y make
yum install -y curl
yum install -y curl-devel
yum install -y zlib-devel
yum install -y perl
yum install -y cpio
yum install -y expat-devel
yum install -y gettext-devel
yum install -y libev-devel
yum install -y c-ares-devel
yum install -y git

