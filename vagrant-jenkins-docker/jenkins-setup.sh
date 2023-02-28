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



# Get the initial admin password
PASSWORD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# Unlock Jenkins with the initial admin password
sudo echo "jenkins.model.Jenkins.instance.securityRealm.createAccount(\"admin\", \"$PASSWORD\")" | sudo java -jar /usr/share/jenkins/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080 --ajp13Port=-1 --httpsPort=-1 --sessionTimeout=86400 --accessLoggerClassName=winstone.accesslog.SimpleAccessLogger --simpleAuth.hudson.model.SimpleUserDetailsService.user=admin

# Restart Jenkins
sudo systemctl restart jenkins

sudo usermod -s /bin/bash jenkins
# Define the new password for the jenkins user
NEW_PASSWORD="Password1"

# Use the passwd command to encrypt the new password
ENCRYPTED_PASSWORD=$(echo "$NEW_PASSWORD" | passwd --stdin jenkins)

# Use the chpasswd command to update the password in the system password database
echo "jenkins:$ENCRYPTED_PASSWORD" | chpasswd


#Add jenkins user to sudoers list
sudo bash -c "echo 'jenkins ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"

sudo mkdir -p /projects/www-static
sudo chown -R jenkins:jenkins /projects

#Generate an SSH key, accept all default values
ssh-keygen -t ecdsa -b 521 -m PEM

#Copy the key to the localhost
sshpass -p Password1 ssh-copy-id jenkins@localhost

sudo systemctl restart jenkins