#!/bin/bash

echo "* Add hosts ..."
echo "192.168.199.100 apache-web docker" >> /etc/hosts


echo "* Add Docker repository ..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install Docker ..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "* Enable and start Docker ..."
systemctl enable docker
systemctl start docker

echo "* Firewall - open port 8080 ..."
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --reload

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant

docker build -t apache-centos - << EOF
FROM    centos:7
RUN yum install httpd httpd-tools -y

EXPOSE  80

CMD     ["/usr/sbin/httpd","-D","FOREGROUND"]

EOF

docker run -d -p 8090:80 -v /home/user/web:/var/www/html apache-centos

echo "<h1>This is Milens container</h1>" >> /home/user/web/index.html

cd /home/user/web/ || return

sudo docker cp index.html apache-centos:/var/www/apache-web/html