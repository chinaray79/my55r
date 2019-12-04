#! /usr/bin/env python
# -*- coding: utf-8 -*-
import os, json,base64
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

	if u"server_remark" not in configfile:
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

# 写入端口函数
def WritePort(myport):
    config[u"server_port"]=int(myport)
    Write()

# 写入加密方式函数
def WriteMethod(mymtd):
    config[u"method"]=str(mymtd)
    Write()

# 写入传输协议函数
def WriteProtocol(myptc):
    config[u"protocol"]=str(myptc)
    Write()

# 写入混淆模式函数
def WriteObfs(myobfs):
    config[u"obfs"]=str(myobfs)
    Write()

# 写入重定向参数函数 
def WriteRedirect(myrdrt): 
    config[u"redirect"]=list(myrdrt) 
    Write()

def IncreasePort(oldport):
	newPort=oldport+1
	WritePort(newPort)
	print "旧的端口："+str(oldport)
	print "新的端口："+str(newPort)
	print ("")
	return newPort

#默认的method(加密)  是：  chacha20-ietf      ssr 2 3 8
#默认的protocal(协议)是：  auth_akarin_rand   ssr 2 3 13
# 但是，这不支持手机使用 
# 加密使用： rc4-md5-6 
# 协议使用： auth_chain_d
def SetMethodProtocal():
	WriteMethod("rc4-md5-6")
	WriteProtocol("auth_chain_d")

#	print "SrvGrp:" + ConfSrvGroup
#	print "Remark:"+ConfSrvInfor
def ShowParameters():
	print "IP地址:" + IP
	print "端口号: " + str(ConfPort)
	print "密码  ：" + ConfPwd
	print "加密  :" + ConfMethod
	print "协议  :" + ConfProtocol
	print "混淆  :" + ConfObfs
	print "服务组:"+ConfSrvGroup
	print "服务器:"+ConfSrvInfor

# 绿色字体
def GreenText(string):
    print("\033[32m")
    print("%s") % string
    print("\033[0m")

def ShowSSRUrl():
	base64Pwd = str(base64.encodestring(str(ConfPwd)))[:-1]
	base64Group=str(base64.encodestring(ConfSrvGroup))[:-1]
	base64Remark=str(base64.encodestring(ConfSrvInfor))[:-1]
	SecondPart = "/?obfsparam="+"&remarks="+base64Remark+"&group="+base64Group

	# ssr客户端链接
	ssr_url=str(GetSsrUrl(IP, str(ConfPort), str(ConfProtocol), str(ConfMethod), str(ConfObfs), base64Pwd, SecondPart))
	GreenText(ssr_url)

#现在暂时不要调用这一句
IncreasePort(ConfPort)
SetMethodProtocal()
ConfPort=config[u"server_port"]
ConfMethod=config[u"method"]
ConfProtocol=config[u"protocol"]
ShowParameters()
ShowSSRUrl()



