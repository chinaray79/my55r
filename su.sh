#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

testfun(){
echo -e "{\n" > config.json
echo -e '    "server":"0.0.0.0",\n' >> config.json
echo -e '    "server_port":14326,\r' >> config.json
echo -e '    "local_address":"127.0.0.1",\r' >> config.json
echo -e '    "local_port":1080,\r' >> config.json
echo -e '    "password":"aatkukb79",\r' >> config.json
echo -e '    "timeout":300,\r' >> config.json
echo -e '    "method":"aes-256-cfb",\r' >> config.json
echo -e '    "fast_open":false\r' >> config.json
echo -e "\r}\r" >> config.json
cat config.json

diff config.json config.bck.json
}

testfun
