#!/bin/sh

./cloud_sql_proxy -instances="$@"=tcp:3306 &
dev_appserver.py --php_executable_path=/usr/local/bin/php-cgi --host 0.0.0.0 /opt/site/
