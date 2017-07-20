#!/bin/sh
DB_LOOPS="20"
START_CMD="bin/azkaban-web-start.sh"

#wait for mariadb
i=0
while ! nc $AZKABAN_MYSQL_HOST $AZKABAN_MYSQL_PORT >/dev/null 2>&1 < /dev/null; do
  i=`expr $i + 1`
  if [ $i -ge $DB_LOOPS ]; then
    echo "$(date) - ${AZKABAN_MYSQL_HOST}:${AZKABAN_MYSQL_PORT} still not reachable, giving up"
    exit 1
  fi
  echo "$(date) - waiting for ${AZKABAN_MYSQL_HOST}:${AZKABAN_MYSQL_PORT}..."
  sleep 1
done

# initialize azkaban db
echo "download azkaban sql script"
curl "http://download.hd123.com/TmpFiles/TA/20170626.6/create-all-sql-2.5.0.sql.tar.gz" | tar xz -C /opt/heading/
echo "import azkaban create-all-sql.sql to $AZKABAN_MYSQL_HOST"
mysql -h$AZKABAN_MYSQL_HOST -P$AZKABAN_MYSQL_PORT -u$AZKABAN_MYSQL_USER -p$AZKABAN_MYSQL_PASSWORD $AZKABAN_MYSQL_DATABASE < /opt/heading/create-all-sql-2.5.0.sql
rm -rf /opt/heading/create-all-sql-2.5.0.sql

sed -i 's:^[ \t]*mysql.host[ \t]*=\([ \t]*.*\)$:mysql.host='${AZKABAN_MYSQL_HOST}':;\
		s:^[ \t]*mysql.port[ \t]*=\([ \t]*.*\)$:mysql.port='${AZKABAN_MYSQL_PORT}':;\
		s:^[ \t]*mysql.database[ \t]*=\([ \t]*.*\)$:mysql.database='${AZKABAN_MYSQL_DATABASE}':;\
		s:^[ \t]*mysql.user[ \t]*=\([ \t]*.*\)$:mysql.user='${AZKABAN_MYSQL_USER}':;\
		s:^[ \t]*mysql.password[ \t]*=\([ \t]*.*\)$:mysql.password='${AZKABAN_MYSQL_PASSWORD}':;\
		s:^[ \t]*executor.host[ \t]*=\([ \t]*.*\)$:executor.host='${AZKABAN_MYSQL_HOST}':' /opt/heading/azkaban-web/conf/azkaban.properties && \
sed -i 's:username=\(\"azkaban\"\):username=\"'${AZKABAN_ADMIN}'\":;\
		s:password=\(\"azkaban\"\):password=\"'${AZKABAN_ADMIN_PASSWORD}'\":;\
		s:password=\(\"metrics\"\):password=\"'${AZKABAN_METRICS_PASSWORD}'\":' /opt/heading/azkaban-web/conf/azkaban-users.xml

cd /opt/heading/azkaban-web && sh $START_CMD
