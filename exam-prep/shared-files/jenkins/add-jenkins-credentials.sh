#!/bin/bash

# 
# Create Jenkins credentials
# 

CRED_ID=$1
CRED_NAME=$2
CRED_PASS=$3

cat <<EOF | java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.99.101:8080/ -http -auth admin:admin create-credentials-by-xml system::system::jenkins _
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
<scope>GLOBAL</scope>
  <id>${CRED_ID}</id>
  <description>${CRED_NAME} username and password pair</description>
  <username>${CRED_NAME}</username>
  <password>${CRED_PASS}</password>                                                                                                             
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
EOF
