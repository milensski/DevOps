#!/bin/bash

echo "* Add required packages"
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release

echo "* Add repository key"
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "* Add the Docker repository"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "* Install the packages (Java, git, Docker)"
apt-get update
apt-get install -y fontconfig openjdk-17-jre git docker-ce docker-ce-cli containerd.io

echo "* Adjust the group membership"
usermod -aG docker vagrant

echo "* Install Docker Compose (for vagrant user)"
mkdir -p /home/vagrant/.docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.12.2/docker-compose-linux-x86_64 -o /home/vagrant/.docker/cli-plugins/docker-compose
chmod +x /home/vagrant/.docker/cli-plugins/docker-compose
chown -R vagrant:vagrant /home/vagrant/.docker

echo "* Copy the Compose plugin for root user"
mkdir -p /root/.docker/cli-plugins
cp /home/vagrant/.docker/cli-plugins/docker-compose /root/.docker/cli-plugins/
