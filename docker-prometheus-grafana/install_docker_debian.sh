#!/bin/bash

echo "* Update repositories and install common packages"
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release tree

echo "* Add Docker repository key"
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "* Add Docker repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "* Install Docker"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "* Adjust group membership"
usermod -aG docker vagrant

cp /vagrant/docker-config/daemon.json /etc/docker/

sudo systemctl restart docker
sudo systemctl enable docker
sudo systemctl start docker