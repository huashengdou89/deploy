###############################################################################
# File Name: HDPOS4.sh
# Author: shujun
# mail: shujun@hd123.com
# Created Time: Mon Aug 15 11:28:17 CST 2016
###############################################################################
#!/bin/bash
ACTION=${ACTION:-install}
H4IMAGE=${H4IMAGE:-hdpos4}
VERSION=${VERSION:-latest}
DOCKERHUB=${DOCKERHUB:-harborka.qianfan123.com}
WEBPORT=${WEBPORT:-18580}
HDPOS4HTTPSPORT=${HDPOS4HTTPSPORT:-18543}
HDPOS4JMXPORT=${HDPOS4JMXPORT:-19548}
HDPOS4REDISPORT=${HDPOS4REDISPORT:-6379}
DEPLOYDIR=${DEPLOYDIR:-data}
LOGDIR=${LOGDIR:-/${DEPLOYDIR}/heading/${ENVNAME}/log_${ENVNAME}/${H4IMAGE}}
FILEDIR=${FILEDIR:-/${DEPLOYDIR}/heading/${ENVNAME}/hdpos4_${ENVNAME}/Enclosure}
HDPOS4REDISDATADIR=${HDPOS4REDISDATADIR:-/${DEPLOYDIR}/heading/${ENVNAME}/hdpos4_${ENVNAME}/redisdata}
EXTRANETHOST=${EXTRANETHOST:-192-168-251-5}
PROTOCOL=http
OLDORAURL=${OLDORAURL:-172.17.11.84:1521:db2}
NEWORAURL=${NEWORAURL:-192.168.251.4:1521:hdappts}
NEWORAUSER=${NEWORAUSER:-hd40}
NEWORAPWD=${NEWORAPWD:-yfrp4vh0bpwg}

#选项后面的冒号表示该选项需要参数
ARGS=`getopt -o v: --long webport: -n 'HDPOS4.sh' -- "$@"`
if [ $? != 0 ]; then
    echo "Terminating..."
    exit 1
fi

#echo $ARGS
#将规范化后的命令行参数分配至位置参数（$1,$2,...)
eval set -- "${ARGS}"

while true
do
    case "$1" in
		-v) 
		    VERSION="$2"; 
			shift 2 ;;
		--webport)
      		WEBPORT="$2"; 
			shift 2 
			;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

#处理剩余的参数
for arg in $@
do
    echo "processing $arg"
done

start_h4redis() {

    ID=$(sudo docker run -d \
	                     --restart=always \
						 -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
						 -p ${HDPOS4REDISPORT}:6379 \
						 -v ${HDPOS4REDISDATADIR}:/data:rw \
						 --name h4-redis_${ENVNAME} \
						 ${DOCKERHUB}/component/redis:2.8) >/dev/null 2>&1
}

start_container() {

    ID=$(sudo docker run -d \
					     -p ${WEBPORT}:8080 \
                         -p ${HDPOS4HTTPSPORT}:8443 \
						 -p ${HDPOS4JMXPORT}:${HDPOS4JMXPORT} \
					     -v ${LOGDIR}:/opt/heading/tomcat7/logs \
						 -v ${FILEDIR}:/opt/heading/Enclosure \
						 -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
					     --restart=on-failure:3 \
					     --log-opt max-size=50m \
					     -m 16g \
						 -e JAVA_OPTS="-server -Xms4096m -Xmx16384m -XX:PermSize=256M -XX:MaxPermSize=512M -Duser.timezone=GMT+08 -Dfile.encoding=UTF-8 -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=${HDPOS4JMXPORT} -Dcom.sun.management.jmxremote.rmi.port=${HDPOS4JMXPORT} -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.local.only=false -Djava.rmi.server.hostname=${INTRANETIP}" \
					     --name ${H4IMAGE}_${ENVNAME} ${DOCKERHUB}/hdpos46/${H4IMAGE}-dist:${VERSION}) >/dev/null 2>&1
}

deploying_container() {

    ID=$(sudo docker exec \
						-e COLDORAURL="${OLDORAURL}" \
						-e CNEWORAURL="${NEWORAURL}" \
						-e CNEWORAUSER="${NEWORAUSER}" \
						-e CNEWORAPWD="${NEWORAPWD}" \
						${H4IMAGE}_${ENVNAME} sh -c '
												sed -i  "
													s%\r$%%;\
													/url/s%${COLDORAURL}%${CNEWORAURL}%;\
													s%password=hd40%password=${CNEWORAPWD}%;\
													s%username=hd40%username=${CNEWORAUSER}%;\
													s%default_schema=hd40%default_schema=${CNEWORAUSER}%;\
													s%runMode=development%runMode=production%" /opt/heading/tomcat7/webapps/hdpos4-web/WEB-INF/classes/hdpos4-web.properties') >/dev/null 2>&1
}

pull_image() {
    set +e
    echo "Waiting for pull ${H4IMAGE}"
	until
		(sudo docker login -u ${DOCKERHUBUSER} -p ${DOCKERHUBUSERPW} ${DOCKERHUB};
		 sudo docker pull ${DOCKERHUB}/hdpos46/${H4IMAGE}-dist:${VERSION} | sudo tee /tmp/${IMAGE}-${VERSION}_pull.log;
		);do
		printf '.'
		sleep 1
	done
}

export -f pull_image

cpout_config() {
    sudo docker cp ${H4IMAGE}_${ENVNAME}:/opt/heading/tomcat7/webapps/hdpos4-web/WEB-INF/classes/${H4IMAGE}-web.properties ${ConfPath}
}

cpin_config() {
    sudo docker cp ${ConfPath}/${H4IMAGE}-web.properties ${H4IMAGE}_${ENVNAME}:/opt/heading/tomcat7/webapps/hdpos4-web/WEB-INF/classes/
}

if [ "${ACTION}" = "install" ]; then
	set -e
    get_ip
	get_exip
    pull_image
	image_exist
    h4redis_exist
	container_exist
	
	echo "Install and deploying ${H4IMAGE}"
    echo "## Install begins : ${H4IMAGE}"
    start_container
    if [ $? -ne 0 ]; then
		echo "Install failed..."
		exit 1
    fi
    echo "## Install ends   : ${H4IMAGE}"
	sleep 15
	echo "## deploying begins : ${H4IMAGE}"
    deploying_container
    if [ $? -ne 0 ]; then
		echo "deploying failed..."
		exit 1
    fi
    echo "## deploying ends   : ${H4IMAGE}"
	
	sleep 10
	echo "Restart ${H4IMAGE}"
	restart_container
	cpout_config
	
    echo "${H4IMAGE} available at ${PROTOCOL}://${INTRANETIP}:${WEBPORT}/${H4IMAGE}-web or ${PROTOCOL}://${EXTRANETIP}:${WEBPORT}/${H4IMAGE}-web"
	echo "Done."
elif [ "${ACTION}" = "redeploy" ]; then
	pro_redeploy
    echo "${H4IMAGE} available at ${PROTOCOL}://${INTRANETIP}:${WEBPORT}/${H4IMAGE}-web or ${PROTOCOL}://${EXTRANETIP}:${WEBPORT}/${H4IMAGE}-web"
	echo "Done."
else
    echo "Unknown action ${ACTION}"
    exit 1
fi
