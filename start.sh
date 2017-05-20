#!/bin/bash
# mysql setup
if [ ! -f /setup.txt ]; then
service mysql start
#sleep 10s
#  mysqld_safe --skip-grant-tables --skip-networking &
  sleep 10s
  # Here we generate random passwords (thank you pwgen!) for mysql users
  MYSQL_PASSWORD=`pwgen -c -n -1 12`
  #This is so the passwords show up in logs.
  echo mysql root password: $MYSQL_PASSWORD
  echo $MYSQL_PASSWORD > /mysql-root-pw.txt
  echo "SETUPOK" > /setup.txt


 # mysqladmin -u root password $MYSQL_PASSWORD
#mysql -uroot -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$MYSQL_PASSWORD'); flush privileges; quit"
#service mysql stop
#service mysql start

  #mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTIO$

 # mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' $
mysql -uroot -e "CREATE DATABASE yuli; GRANT ALL PRIVILEGES ON yuli.* TO 'yuli'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;"
  #killall mysqld
cd /usr/share/nginx/www
wp --allow-root core download
wp --allow-root core config --dbhost="localhost" --dbname="yuli" --dbuser="yuli" --dbpass="$MYSQL_PASSWORD"
chown -R www-data:www-data ./*
service mysql stop
/etc/init.d/ssh start
service mysql start
/etc/init.d/php7.0-fpm start
service nginx restart
fi
