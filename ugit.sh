#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

myroot=/root

if [ -d "${myroot}/my55r" ] ; then
	cd ${myroot}/my55r
	git pull
else
	cd ${myroot}
	git clone https://github.com/chinaray79/my55r
	\cp -f my55r/ugit.sh ./u.sh
fi
cd ${myroot}
\cp -f my55r/*.sh ./
\cp -f my55r/*.py ./
cd ${myroot}
chmod 777 *.sh 
chmod 777 *.py 
