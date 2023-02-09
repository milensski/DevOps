#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.do1.lab web" >> /etc/hosts
echo "192.168.89.101 db.do1.lab db" >> /etc/hosts

echo "* Install Software ..."
apt-get update -y && apt-get upgrade -y
apt-get install -y apache2 php php-mysqlnd

echo "* Remove the default index.html file ..."
rm /var/www/html/index.html

echo "* Copy web site files to /var/www/html/ ..."
cp /vagrant/* /var/www/html
