#!/bin/bash

echo "* Add any prerequisites ..."
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release
echo "* Done..."

echo "* Add Docker repository and key ..."
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "* Done..."

echo "* Install Docker ..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
echo "* Done..."

echo "* Add vagrant user to docker group ..."
usermod -aG docker vagrant
echo "* Done..."
echo "* Add jenkins user to docker group ..."
usermod -aG docker jenkins
echo "* Done..."
echo "* Restart Jenkins ..."
sudo service jenkins restart
echo "* Done..."