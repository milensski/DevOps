#!/bin/bash

echo "* Add hosts ..."
echo "192.168.199.100 docker.do1.lab docker" >> /etc/hosts

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
