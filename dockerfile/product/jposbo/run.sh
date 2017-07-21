#!/bin/sh
# wait-for-mysql.sh
set -e
cmd="sh /opt/heading/tomcat6/bin/catalina.sh run"
until mysql -h$JPOSBO_MYSQL_HOST -P$JPOSBO_MYSQL_PORT -u$JPOSBO_MYSQL_USER -p$JPOSBO_ROOT_PASSWORD -e "select version();";do
  >&2 echo "Mysql is unavailable - sleeping"
  sleep 1
done

>&2 echo "Mysql is up - executing command"
exec $cmd

