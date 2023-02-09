#!/bin/bash

echo "* Add hosts ..."
echo "192.168.89.100 web.do1.lab web" >> /etc/hosts
echo "192.168.89.101 db.do1.lab db" >> /etc/hosts

echo "* Install Software ..."
apt-get update -y && apt-get upgrade -y
apt-get install -y mariadb-server

echo "* Adjust MariaDB connectivity ..."
sudo sed -i.bak s/127.0.0.1/0.0.0.0/g /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb

echo "* Create and load the database ..."
mysql -u root < /vagrant/db_setup.sql
