#! /usr/bin/env python
# -*- coding: utf-8 -*-
import os, json
from ssrextra import (byteify,is_internal_ip, get_host_ip, look_ip_from, GetSsrUrl, genQR_Code)

# 打开配置文件
jsonfile = file("/etc/shadowsocks.json")
configfile = json.load(jsonfile)
config = byteify(configfile)

# 写入配置文件
def Write():
    myjsondump=json.dumps(config,indent=4) # json.dumps方法用于将对象格式化成json，indent定义了缩进
    openjsonfile=file("/etc/shadowsocks.json","w+") # file方法用于打开文件，w+参数表示可读写
    openjsonfile.writelines(myjsondump) # writelines方法用于向文件写入一个序列字符串列表
    openjsonfile.close() # close方法表示关闭文件。关闭后文件不能再进行读写操作。

# cp shadowsocks.org.json /etc/shadowsocks.json
def InitServerInfor():
	if u"server_group" not in configfile:
		print "请输入服务器组名称:"
		groupinput=raw_input()
		if len(groupinput)>1 :
			config[u"server_group"]=groupinput
		else:
			config[u"server_group"]="Ray"
		Write()

	if u"remarkinput" not in configfile:
		print "请输入服务器标注："
		remarkinput=raw_input()
		if len(remarkinput)>1 :
			config[u"server_remark"]=remarkinput
		else:
			config[u"server_remark"]="NotDefine"
		Write()

InitServerInfor()

# 读取传入配置细则
ConfPort=config[u"server_port"]
ConfPwd=config[u"password"]
ConfMethod=config[u"method"]
ConfProtocol=config[u"protocol"]
ConfObfs=config[u"obfs"]
ConfRedirect=config[u"redirect"]
ConfSrvGroup=config[u"server_group"]
ConfSrvInfor=config[u"server_remark"]

# 获取本机IP地址
# 默认采用发送 UDP 数据包的方式获取 IP 地址
thisip = get_host_ip()
IP = str(thisip)

#	print "SrvGrp:" + ConfSrvGroup
#	print "Remark:"+ConfSrvInfor
def ShowParameters():
	print("\033[32m")
	print "IP地址:" + IP
	print "端口号:" + str(ConfPort)
	print "密码  :" + ConfPwd
	print "加密  :" + ConfMethod
	print "协议  :" + ConfProtocol
	print "混淆  :" + ConfObfs
	print "服务组:"+config[u"server_group"]
	print "标注  :"+config[u"server_remark"]
	print("\033[0m")


def ConfServer():
	print "请输入服务器组名称(" + config[u"server_group"] + ") :"
	newinput=raw_input()
	if len(newinput)>1 :
		config[u"server_group"]=newinput
	else:
		print "没有改变："+config[u"server_group"]
	print "请输入服务器组标注("+config[u"server_remark"]+"):"
	remarkinput=raw_input()
	if len(remarkinput)>1 :
		config[u"server_remark"]=remarkinput
	else:
		print "没有改变标："+config[u"server_remark"]
	Write()

ConfServer()
ShowParameters()
