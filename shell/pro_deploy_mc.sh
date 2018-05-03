#################################################
# File Name: pro_deploy.sh
# Author: shujun
# mail: shujun@hd123.com
# Created Time: Mon Aug 15 11:28:17 CST 2016
#################################################
#!/bin/bash
set +e
echo '## Deploy information'
export DOCKERHUBUSER DOCKERHUBUSERPW ORAURL ORAUSER ORAPWD DATAMANAGERVERSION DATAMANAGERPORT MONGOPORT LIST EXTRANETIP EXTRANETHOST ENVNAME ACTION DEPLOYDIR
#################################################
#登录Dockerhub用户
DOCKERHUBUSER=""
#登录Dockerhub密码
DOCKERHUBUSERPW=""
#################################################


#################################################
#Oracle数据库连接配置
ORAURL="172.17.11.89:1521:db1"
#Oracle数据库hd40用户
ORAUSER="hd40"
#Oracle数据库hd40用户密码
ORAPWD="hd40"
#################################################


#################################################
#Dts-store版本
DATAMANAGERVERSION="0.0.1-SNAPSHOT"
#Dts-store-http端口
DATAMANAGERPORT="8380"
#Mongodb端口
MONGOPORT="27018"
#################################################


#################################################
#宿主机自定义hostname
EXTRANETHOST="ka1"
#宿主机外网ip
EXTRANETIP="172.17.12.23"
#日志等存放路径
DEPLOYDIR="datamanagernew"
#正式环境or预演环境
ENVNAME="test"
#################################################


#################################################
#需要安装产品列表,可选值"DATAMANAGER",一定要大写,注意空格
LIST="DATAMANAGER"
#初次安装还是重新部署,可选值install
ACTION="install"
#################################################


download_script(){
	date
	type wget >/dev/null 2>&1 || { echo >&2 "wget is not installed"; yum -y install wget; }
	type unzip >/dev/null 2>&1 || { echo >&2 "unzip zip is not installed"; yum -y install zip unzip; }
	wget -q https://raw.githubusercontent.com/huashengdou89/deploy/develop/shell/datamc.zip 
	unzip -qo script.zip -d ${PWD} | xargs rm *.zip*
	type docker >/dev/null 2>&1 || { echo >&2 "docker is not installed"; sh docker_install.sh; }
	bash Public.sh
	ls *.sh | grep -v pro_deploy.sh | xargs rm
	date
}
download_script
