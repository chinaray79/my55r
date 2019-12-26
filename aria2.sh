cd ~
mkdir aria2
cd aria2

yum -y install wget unzip curl
wget https://github.com/helloxz/ccaa/archive/master.zip
unzip master.zip && cd ccaa-master && sh ccaa.sh
