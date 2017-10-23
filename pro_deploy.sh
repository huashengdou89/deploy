#################################################
# File Name: pro_deploy.sh
# Author: shujun
# mail: shujun@hd123.com
# Created Time: Mon Aug 15 11:28:17 CST 2016
#################################################
#!/bin/bash
set +e
echo '## Deploy information'
export DOCKERHUBUSER DOCKERHUBUSERPW DOCKERHUBUSEREM NEWORAURL NEWORAUSER NEWORAPWD NEWPFSPWD DTSVERSION PFSVERSION JPOSBOVERSION OTTERVERSION HDPOS4VERSION RESTVERSION DTSPORT PFSPORT JPOSBOPORT OTTERPORT HDPOS4PORT RESTPORT DEPLOYDIR NEWLIC MYSQL_ROOT_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD MYSQLPORT NEWPFSUSER LIST EXTRANETIP EXTRANETHOST ENVNAME OLDMYSQL_URL NEWCARDORAURLN NEWCARDORAURLS CARDVERSION CARDSERVERPORT CTPORT HQPORT NEWCARDCTS NEWCARDCTN NEWCARDHQN NEWCARDHQS NEWVER CARDSERVERVERSION ACTION JPOSBONAME PASOREPORTVERSION PASOREPORTPORT PAMYSQLPORT PAREDISPORT PAMYSQL_ROOT_PASSWORD PAMYSQL_DATABASE PAMYSQL_USER PAMYSQL_PASSWORD HQMPORT CTMPORT JCRMVERSION JCRMPORT AZKABANVERSION AZKABANPORT AZMYSQLPORT AZMYSQL_DATABASE AZMYSQL_USER AZMYSQL_PASSWORD AZEXECUTORPORT CSPORT
#################################################
#��¼Dockerhub�û�
DOCKERHUBUSER=""
#��¼Dockerhub����
DOCKERHUBUSERPW=""
#��¼Dockerhub�û�����
#DOCKERHUBUSEREM=""
#################################################


#################################################
#Oracle���ݿ���������
NEWORAURL="172.17.12.22:1521:hdpos4"
#Oracle���ݿ�hd40�û�
NEWORAUSER="hd40"
#Oracle���ݿ�hd40�û�����
NEWORAPWD="hd40"
#Oracle���ݿ�pfs�û�
NEWPFSUSER="hd40"
#Oracle���ݿ�pfs�û�����
NEWPFSPWD="hd40"
#���֤��ַ
NEWLIC="172.17.12.206"
#Card��ͨ����������
NEWCARDORAURLN="172.17.12.22:1521:HDCARDN"
#Card��Ҫ����������
NEWCARDORAURLS="172.17.12.22:1521:HDCARDS"
#Cardcts�û���&����
NEWCARDCTS="hdcardcts"
#Cardctn�û���&����
NEWCARDCTN="hdcardctn"
#Cardhqs�û���&����
NEWCARDHQS="hdcardhqs"
#Cardhqn�û���&����
NEWCARDHQN="hdcardhqn"
#Card��Ҫ�����İ汾
NEWVER="48"
#################################################


#################################################
#Dts-store�汾
DTSVERSION="1.13.1"
#Dts-store�˿�
DTSPORT="8180"
#################################################


#################################################
#Pfs�汾
PFSVERSION="2.7"
#Pfs�˿�
PFSPORT="8280"
#################################################


#################################################
#Jposbo��Ŀ����
JPOSBONAME="hdpos46std"
#Jposbo�汾
JPOSBOVERSION="hdpos46std_2017071_pro"
#Jposbo�˿�
JPOSBOPORT="8380"
#Jposbo-Mysql�˿�
MYSQLPORT="3306"
#Jposbo-Mysql����Ա�û�����
MYSQL_ROOT_PASSWORD="headingjpos"
#Jposbo-Mysql����jposbo���ݿ�����
MYSQL_DATABASE="jposbo"
#Jposbo-Mysql����jposbo���ݿ��û�
MYSQL_USER="heading"
#Jposbo-Mysql����jposbo���ݿ��û�����
MYSQL_PASSWORD="heading"
#################################################


#################################################
#Pasoreport�汾
PASOREPORTVERSION="1.1.1"
#Pasoreport�˿�
PASOREPORTPORT="18980"
#Pasoreport-Mysql�˿�
PAMYSQLPORT="13306"
#Pasoreport-Redis�˿�
PAREDISPORT="16379"
#Pasoreport-Mysql����Ա�û�����
PAMYSQL_ROOT_PASSWORD="hG4uWDsgcHmvyte4"
#Pasoreport-Mysql����Pasoreport���ݿ�����
PAMYSQL_DATABASE="pasoreport"
#Pasoreport-Mysql����Pasoreport���ݿ��û�
PAMYSQL_USER="pasoreport"
#Pasoreport-Mysql����Pasoreport���ݿ��û�����
PAMYSQL_PASSWORD="hG4uWDsgcHmvyte4"
#################################################


#################################################
#Otter-r3�汾
OTTERVERSION="1.35"
#Otter-r3�˿�
OTTERPORT="8480"
#################################################


#################################################
#Hdpos4.6�汾
HDPOS4VERSION="1.0"
#Hdpos4.6�˿�
HDPOS4PORT="8580"
#################################################


#################################################
#H4rest�汾
RESTVERSION="1.21"
#H4rest�˿�
RESTPORT="28580"
#################################################


#################################################
#H4rest�汾
RESTVERSION="1.21"
#H4rest�˿�
RESTPORT="28580"
#################################################


#################################################
#Card�汾
CARDVERSION="3.48"
#Card�ܲ��˿�
HQPORT="8680"
#Card���Ķ˿�
CTPORT="8780"
#Cardserver�˿�
CSPORT="8880"
#Card������Ϣͨ�Ŷ˿�
CTMPORT="1199"
#Card�ܲ���Ϣͨ�Ŷ˿�
HQMPORT="1299"
#################################################


#################################################
#������װCardserver�������øò�����Ϣ���������
#Cardserver�汾
CARDSERVERVERSION="3.47"
#Cardserver�˿�
CARDSERVERPORT="8880"
#################################################


#################################################
#Jcrm�汾
JCRMVERSION="2.0.18"
#Jcrm�˿�
JCRMPORT="8980"
#################################################


#################################################
#Azkaban�汾
AZKABANVERSION="latest"
#Azkaban�˿�
AZKABANPORT="28443"
#Azkaban-Mysql�˿�
AZMYSQLPORT="43306"
#Azkaban-executor�˿�
AZEXECUTORPORT="12321"
#Azkaban-Mysql����Azkaban���ݿ�����
AZMYSQL_DATABASE="azkaban"
#Azkaban-Mysql����Azkaban���ݿ��û�
AZMYSQL_USER="azkaban"
#Azkaban-Mysql����Azkaban���ݿ��û�����
AZMYSQL_PASSWORD="azkaban"
#################################################


#################################################
#�������Զ���hostname
EXTRANETHOST="hdpos"
#����������ip
EXTRANETIP="172.17.12.23"
#��־�ȴ��·��
DEPLOYDIR="data"
#��ʽ����orԤ�ݻ���
ENVNAME="jichen"
#################################################


#################################################
#��Ҫ��װ��Ʒ�б�,��ѡֵ"DTS PFS JPOSBO CARD CARDSERVER OTTER HDPOS4 REST PASOREPORT JCRM AZKABAN",һ��Ҫ��д,ע��ո�
LIST="JPOSBO"
#���ΰ�װ�������²���,��ѡֵinstall|redeploy
ACTION="install"
#################################################


#����������������
OLDMYSQL_URL="172.17.2.116\/jposbo${JPOSBONAME}"

download_script(){
	date
	type wget >/dev/null 2>&1 || { echo >&2 "wget is not installed"; yum -y install wget; }
	type unzip >/dev/null 2>&1 || { echo >&2 "unzip zip is not installed"; yum -y install zip unzip; }
	wget -q https://raw.githubusercontent.com/huashengdou89/deploy/develop/shell/script.zip 
	unzip -qo script.zip -d ${PWD} | xargs rm *.zip*
	type docker >/dev/null 2>&1 || { echo >&2 "docker is not installed"; sh docker_install.sh; }
	bash Public.sh
	ls *.sh | grep -v pro_deploy1.0.sh | xargs rm
	date
}
download_script