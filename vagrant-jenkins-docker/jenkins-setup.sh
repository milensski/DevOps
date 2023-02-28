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

sudo systemctl enable jenkins

echo "* Restart Jenkins ..."
sudo systemctl restart jenkins

echo "* Add user jenkins ..."
sudo usermod -s /bin/bash jenkins

echo "* Define the new password for the jenkins user ..."
echo -e "Password1\nPassword1" | passwd jenkins

echo "* Add jenkins user to sudoers list ..."
sudo bash -c "echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"


echo "* Make dir for jenkins and change owner ..."
sudo mkdir -p /projects/www-static
sudo chown -R jenkins:jenkins /projects

#Not neccessery for this homework but...
echo "* Generate an SSH key, accept all default values ..."
ssh-keygen -t ecdsa -b 521 -m PEM

echo "* Copy the key to the localhost ..."
sshpass -p Password1 ssh-copy-id jenkins@localhost

echo "* Restart Jenkins ..."
sudo systemctl restart jenkins

echo "* Restart Jenkins ..."

PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
echo "Jenkins initialPassword ---->  $PASSWORD"