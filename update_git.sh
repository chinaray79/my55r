#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
rm my55r -rf
git clone https://github.com/chinaray79/my55r
cp my55r/*.sh ./
chmod 777 *.sh
