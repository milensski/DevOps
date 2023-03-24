#!/bin/bash

echo "* Update repositories and install Java"
apt-get update
apt-get install -y fontconfig openjdk-17-jre groovy git

echo "* Add and import the repository key"
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

echo "* Update repositories and install Jenkins"
apt-get update
apt-get install -y jenkins
