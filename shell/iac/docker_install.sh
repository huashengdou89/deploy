#!/bin/bash
###############################################################################
#
#VARS INIT
#
###############################################################################


###############################################################################
#
#Confirm Env
#
###############################################################################
date
echo "## Install Preconfirm"
echo "## Uname"
uname -r
echo
echo "## OS bit"
getconf LONG_BIT
echo

###############################################################################
#
#INSTALL yum-utils
#
###############################################################################
date
echo "## Install begins : yum-utils"
yum install -y yum-utils \
			   device-mapper-persistent-data \
			   lvm2 >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Install ends   : yum-utils"
echo

###############################################################################
#
#Setting yum-config-manager
#
###############################################################################
echo "## Setting begins : yum-config-manager"
yum-config-manager \
   --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo >/dev/null 2>&1

if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : yum-config-manager"
echo

###############################################################################
#
#Update Package Cache
#
###############################################################################
echo "## Setting begins : Update package cache"
yum makecache fast >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : Update package cache"
echo

###############################################################################
#
#INSTALL Docker-engine
#
###############################################################################
date
echo "## Install begins : docker-ce"
yum install -y docker-ce
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Install ends   : docker-ce"
date
echo

###############################################################################
#
#Stop Firewalld
#
###############################################################################
echo "## Setting begins : stop firewall"
systemctl stop firewalld
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
systemctl disable firewalld
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : stop firewall"
echo

###############################################################################
#
#Clear Iptable rules
#
###############################################################################
echo "## Setting begins : clear iptable rules"
iptables -F
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : clear iptable rules"
echo

###############################################################################
#
#Enable docker
#
###############################################################################
echo "## Setting begins : systemctl enable docker"
systemctl enable docker
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : systemctl enable docker"
echo


###############################################################################
#
#Docker hub accelerator
#
###############################################################################
echo "## Setting begins : Docker hub accelerator"
curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://4e6c7a4c.m.daocloud.io
if [ $? -ne 0 ]; then
  echo "Install failed..."
  exit 1
fi
echo "## Setting ends   : Docker hub accelerator"
echo


###############################################################################
#
#Modify docker root path
#
###############################################################################
echo "## Setting begins : Modify docker root path"
mkdir /etc/docker && > /etc/docker/daemon.json
cat >>/etc/docker/daemon.json<<EOF
{"registry-mirrors": ["http://4e6c7a4c.m.daocloud.io"],
 "graph": "/hdapp/docker",
 "bip": "172.86.0.1/24"
}
EOF
if [ $? -ne 0 ]; then
  echo "Modify failed..."
  exit 1
fi
echo "## Setting ends   : Modify docker root path"
echo


###############################################################################
#
#start docker
#
###############################################################################
echo "## Setting begins : systemctl restart docker"
systemctl daemon-reload && systemctl restart docker
if [ $? -ne 0 ]; then
  echo "Restart failed..."
  exit 1
fi
echo "## Setting ends   : systemctl restart docker"
echo


###############################################################################
#
#confirm docker version
#
###############################################################################
echo "## docker info"
docker info
echo

echo "## docker version"
docker version
