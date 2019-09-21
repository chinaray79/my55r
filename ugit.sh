#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'
  if [ -d "/root/my55r"]; then
    cd /root/my55r
	git pull
  else
    cd /root
	git clone https://github.com/chinaray79/my55r
	cd /root/my55r
	chmod 777 *.sh
  fi

  \cp -f my55r/*.sh ./
  cd /root
  chmod 777 *.sh 
