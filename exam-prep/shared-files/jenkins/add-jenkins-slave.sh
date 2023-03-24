#!/bin/bash

# 
# Add Jenkins slave node
# 

NODE_NAME=$1
NODE_SLAVE_HOME='/home/vagrant'
EXECUTORS=2
SSH_PORT=22
CRED_ID=$2
LABELS=docker-node
USERID=admin

cat <<EOF | java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.99.101:8080/ -http -auth admin:admin create-node $1
<slave>
  <name>${NODE_NAME}</name>
  <description>Jenkins Slave Node</description>
  <remoteFS>${NODE_SLAVE_HOME}</remoteFS>
  <numExecutors>${EXECUTORS}</numExecutors>
  <mode>NORMAL</mode>
  <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
  <launcher class="hudson.plugins.sshslaves.SSHLauncher" plugin="ssh-slaves">
    <host>${NODE_NAME}</host>
    <port>${SSH_PORT}</port>
    <credentialsId>${CRED_ID}</credentialsId>
  </launcher>
  <label>${LABELS}</label>
  <nodeProperties/>
  <userId>${USERID}</userId>
</slave>
EOF
