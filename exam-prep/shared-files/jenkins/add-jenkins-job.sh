#!/bin/bash

# 
# Create Jenkins job
# 

java -jar /home/vagrant/jenkins-cli.jar -s http://192.168.99.101:8080/ -http -auth admin:admin create-job Exam < /vagrant/jenkins/exam-job.xml
