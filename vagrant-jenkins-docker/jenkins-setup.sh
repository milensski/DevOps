#!/bin/bash

echo "* Add any prerequisites ..."
echo "192.168.99.100 jenkins.do1.lab jenkins" >> /etc/hosts
sudo apt-get update
sudo apt-get -y install fontconfig openjdk-17-jre

echo "* Add Jenkins repository and key ..."
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "Installing git"
sudo apt-get -y install git 

echo "* Install Jenkins ..."
sudo apt-get update
sudo apt-get -y install jenkins
# sudo service jenkins start

# sleep 1m
# sudo usermod -s /bin/bash jenkins
# sudo passwd jenkins
# su - jenkins
# pwd
# ssh-keygen -t ecdsa -b 521 -m PEM

# echo "Installing Jenkins Plugins"
# JENKINSPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
# echo $JENKINSPWD

