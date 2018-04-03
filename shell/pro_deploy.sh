#################################################
# File Name: pro_deploy.sh
# Author: shujun
# mail: shujun@hd123.com
# Created Time: Mon Aug 15 11:28:17 CST 2016
#################################################
#!/bin/bash
set +e
echo '## Deploy information'
export DOCKERHUBUSER DOCKERHUBUSERPW NEWORAURL NEWORAUSER NEWORAPWD NEWPFSPWD DTSVERSION PFSVERSION JPOSBOVERSION OTTERVERSION HDPOS4VERSION RESTVERSION DTSPORT PFSPORT JPOSBOPORT OTTERPORT HDPOS4PORT RESTPORT DEPLOYDIR NEWLIC MYSQL_ROOT_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD MYSQLPORT NEWPFSUSER LIST EXTRANETIP EXTRANETHOST ENVNAME OLDMYSQL_URL NEWCARDORAURLN NEWCARDORAURLS CARDVERSION CARDSERVERPORT CTPORT HQPORT NEWCARDCTS NEWCARDCTN NEWCARDHQN NEWCARDHQS NEWVER CARDSERVERVERSION ACTION JPOSBONAME PASOREPORTVERSION PASOREPORTPORT PAMYSQLPORT PAREDISPORT PAMYSQL_ROOT_PASSWORD PAMYSQL_DATABASE PAMYSQL_USER PAMYSQL_PASSWORD HQMPORT CTMPORT JCRMVERSION JCRMPORT AZKABANVERSION AZKABANPORT AZMYSQLPORT AZMYSQL_DATABASE AZMYSQL_USER AZMYSQL_PASSWORD AZEXECUTORPORT CSPORT DTSHTTPSPORT JPOSBOHTTPSPORT PASOREPORTHTTPSPORT PFSHTTPSPORT OTTERHTTPSPORT HDPOS4HTTPSPORT RESTHTTPSPORT JCRMHTTPSPORT DTSJMXPORT PFSJMXPORT HDPOS4JMXPORT RESTJMXPORT JCRMJMXPORT PASOREPORTJMXPORT IANEWORAPWD IAVERSION IAPORT IANEWORAURL LDAPURL HQHTTPSPORT CTHTTPSPORT CSHTTPSPORT CABLEVERSION CABLEPORT CABLEHTTPSPORT CABLEJMXPORT PANTHERVERSION PANTHERPORT PANTHERHTTPSPORT PANTHERJMXPORT PANTHERTASKVERSION PANTHERTASKPORT PANTHERTASKHTTPSPORT PANTHERTASKJMXPORT POSTDBNAME POSTUSER POSTPWD POSTPORT
#################################################
#登录Dockerhub用户
DOCKERHUBUSER=""
#登录Dockerhub密码
DOCKERHUBUSERPW=""
#################################################


#################################################
#Oracle数据库连接配置
NEWORAURL="172.17.12.22:1521:hdpos4"
#Oracle数据库hd40用户
NEWORAUSER="hd40"
#Oracle数据库hd40用户密码
NEWORAPWD="hd40"
#Oracle数据库pfs用户
NEWPFSUSER="hd40"
#Oracle数据库pfs用户密码
NEWPFSPWD="hd40"
#Oracle数据库IA库连接配置
IANEWORAURL="172.17.12.22:1521:ia"
#Oracle数据库IA库密码
IANEWORAPWD="hd40"
#Ldap数据库连接配置
LDAPURL="172.17.12.22:389"
#许可证地址
NEWLIC="172.17.12.206"
#Card普通库连接配置
NEWCARDORAURLN="172.17.12.22:1521:HDCARDN"
#Card机要库连接配置
NEWCARDORAURLS="172.17.12.22:1521:HDCARDS"
#Cardcts用户名&密码
NEWCARDCTS="hdcardcts"
#Cardctn用户名&密码
NEWCARDCTN="hdcardctn"
#Cardhqs用户名&密码
NEWCARDHQS="hdcardhqs"
#Cardhqn用户名&密码
NEWCARDHQN="hdcardhqn"
#Card需要升级的版本
NEWVER="48"
#################################################


#################################################
#Dts-store版本
DTSVERSION="1.13.1"
#Dts-store-http端口
DTSPORT="8180"
#Dts-store-https端口
DTSHTTPSPORT="8143"
#Dts-store监控端口
DTSJMXPORT="9148"
#################################################


#################################################
#Panther-dts-sever版本
PANTHERVERSION="1.0"
#Panther-dts-sever-http端口
PANTHERPORT="9180"
#Panther-dts-sever-https端口
PANTHERHTTPSPORT="9143"
#Panther-dts-sever监控端口
PANTHERJMXPORT="19148"
#Panther-taskweb版本
PANTHERTASKVERSION="1.0"
#Panther-taskweb-http端口
PANTHERTASKPORT="9280"
#Panther-taskweb-https端口
PANTHERTASKHTTPSPORT="9243"
#Panther-taskweb监控端口
PANTHERTASKJMXPORT="19147"
#Panther-postgresql数据库名称
POSTDBNAME="hdtest1"
#Panther-postgresql数据库用户
POSTUSER="daor1"
#Panther-postgresql数据库用户密码
POSTPWD="hd54321"
#Panther-postgresql数据库端口
POSTPORT="54352"
#################################################


#################################################
#Pfs版本
PFSVERSION="2.7"
#Pfs-http端口
PFSPORT="8280"
#Pfs-https端口
PFSHTTPSPORT="8243"
#Pfs监控端口
PFSJMXPORT="9248"
#################################################


#################################################
#Jposbo项目名称
JPOSBONAME="hdpos46std"
#Jposbo版本
JPOSBOVERSION="hdpos46std_2017071_pro"
#Jposbo-http端口
JPOSBOPORT="8380"
#Jposbo-https端口
JPOSBOHTTPSPORT="8343"
#Jposbo-Mysql端口
MYSQLPORT="3306"
#Jposbo-Mysql管理员用户密码
MYSQL_ROOT_PASSWORD="headingjpos"
#Jposbo-Mysql创建jposbo数据库名称
MYSQL_DATABASE="jposbo"
#Jposbo-Mysql创建jposbo数据库用户
MYSQL_USER="heading"
#Jposbo-Mysql创建jposbo数据库用户密码
MYSQL_PASSWORD="heading"
#################################################


#################################################
#Otter-r3版本
OTTERVERSION="1.35"
#Otter-r3-http端口
OTTERPORT="8480"
#Otter-r3-https端口
OTTERHTTPSPORT="8443"
#################################################


#################################################
#Cable版本
CABLEVERSION="latest"
#Cable-http端口
CABLEPORT="38480"
#Cable-https端口
CABLEHTTPSPORT="38443"
#Cable监控端口
CABLEJMXPORT="39548"
#################################################


#################################################
#Hdpos4.6版本
HDPOS4VERSION="1.0"
#Hdpos4.6-http端口
HDPOS4PORT="8580"
#Hdpos4.6-https端口
HDPOS4HTTPSPORT="8543"
#Hdpos4.6监控端口
HDPOS4JMXPORT="9548"
#################################################


#################################################
#H4rest版本
RESTVERSION="1.21"
#H4rest-http端口
RESTPORT="8680"
#H4rest-https端口
RESTHTTPSPORT="8643"
#H4rest监控端口
RESTJMXPORT="9648"
#################################################


#################################################
#Card版本
CARDVERSION="3.48"
#Card总部-http端口
HQPORT="8780"
#Card总部-https端口
HQHTTPSPORT="8743"
#Card中心-http端口
CTPORT="8880"
#Card中心-https端口
CTHTTPSPORT="8843"
#Cardserver-http端口
CSPORT="8980"
#Cardserver-https端口
CSHTTPSPORT="8943"
#Card中心信息通信端口
CTMPORT="1199"
#Card总部信息通信端口
HQMPORT="1299"
#################################################


#################################################
#单独安装Cardserver才需配置该部分信息，否则忽略
#Cardserver版本
CARDSERVERVERSION="3.48"
#Cardserver-http端口
CARDSERVERPORT="8181"
#################################################


#################################################
#Jcrm版本
JCRMVERSION="2.0.18"
#Jcrm-http端口
JCRMPORT="8182"
#Jcrm-https端口
JCRMHTTPSPORT="8743"
#Jcrm-jmx端口
JCRMJMXPORT="9748"
#################################################


#################################################
#Pasoreport版本
PASOREPORTVERSION="1.1.1"
#Pasoreport-http端口
PASOREPORTPORT="8183"
#Pasoreport-https端口
PASOREPORTHTTPSPORT="8843"
#Pasoreport监控端口
PASOREPORTJMXPORT="9848"
#Pasoreport-Mysql端口
PAMYSQLPORT="13306"
#Pasoreport-Redis端口
PAREDISPORT="16379"
#Pasoreport-Mysql管理员用户密码
PAMYSQL_ROOT_PASSWORD="hG4uWDsgcHmvyte4"
#Pasoreport-Mysql创建Pasoreport数据库名称
PAMYSQL_DATABASE="pasoreport"
#Pasoreport-Mysql创建Pasoreport数据库用户
PAMYSQL_USER="pasoreport"
#Pasoreport-Mysql创建Pasoreport数据库用户密码
PAMYSQL_PASSWORD="hG4uWDsgcHmvyte4"
#################################################


#################################################
#IA版本
IAVERSION="5.4.1"
#IA-http端口
IAPORT="8184"
#################################################


#################################################
#Azkaban版本
AZKABANVERSION="1.0"
#Azkaban-https端口
AZKABANPORT="28443"
#Azkaban-Mysql端口
AZMYSQLPORT="43306"
#Azkaban-executor端口
AZEXECUTORPORT="12321"
#Azkaban-Mysql创建Azkaban数据库名称
AZMYSQL_DATABASE="azkaban"
#Azkaban-Mysql创建Azkaban数据库用户
AZMYSQL_USER="azkaban"
#Azkaban-Mysql创建Azkaban数据库用户密码
AZMYSQL_PASSWORD="azkaban"
#################################################


#################################################
#宿主机自定义hostname
EXTRANETHOST="ka1"
#宿主机外网ip
EXTRANETIP="172.17.12.23"
#日志等存放路径
DEPLOYDIR="newpa"
#正式环境or预演环境
ENVNAME="test"
#################################################


#################################################
#需要安装产品列表,可选值"DTS PFS JPOSBO CARD CARDSERVER OTTER HDPOS4 REST PASOREPORT JCRM AZKABAN IA CABLE PANTHER PANTHERTASK",一定要大写,注意空格
LIST="PANTHER PANTHERTASK"
#初次安装还是重新部署,可选值install|redeploy
ACTION="install"
#################################################


#以下内容无需配置
OLDMYSQL_URL="172.17.2.116\/jposbo${JPOSBONAME}"

download_script(){
	date
	type wget >/dev/null 2>&1 || { echo >&2 "wget is not installed"; yum -y install wget; }
	type unzip >/dev/null 2>&1 || { echo >&2 "unzip zip is not installed"; yum -y install zip unzip; }
	wget -q https://raw.githubusercontent.com/huashengdou89/deploy/develop/shell/script.zip 
	unzip -qo script.zip -d ${PWD} | xargs rm *.zip*
	type docker >/dev/null 2>&1 || { echo >&2 "docker is not installed"; sh docker_install.sh; }
	bash Public.sh
	ls *.sh | grep -v pro_deploy.sh | xargs rm
	date
}
download_script
