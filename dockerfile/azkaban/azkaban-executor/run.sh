#!/bin/sh
START_CMD="bin/azkaban-executor-start.sh"

sed -i 's:^[ \t]*mysql.host[ \t]*=\([ \t]*.*\)$:mysql.host='${AZKABAN_MYSQL_HOST}':;\
		s:^[ \t]*mysql.port[ \t]*=\([ \t]*.*\)$:mysql.port='${AZKABAN_MYSQL_PORT}':;\
		s:^[ \t]*mysql.database[ \t]*=\([ \t]*.*\)$:mysql.database='${AZKABAN_MYSQL_DATABASE}':;\
		s:^[ \t]*mysql.user[ \t]*=\([ \t]*.*\)$:mysql.user='${AZKABAN_MYSQL_USER}':;\
		s:^[ \t]*mysql.password[ \t]*=\([ \t]*.*\)$:mysql.password='${AZKABAN_MYSQL_PASSWORD}':' /opt/heading/azkaban-executor/conf/azkaban.properties

cd /opt/heading/azkaban-executor && sh $START_CMD