#!/bin/bash
sudo yum update -y
#sudo yum install epel-release -y
#sudo yum update -y
#sudo yum install tree vim python27 atop jq wget curl python-pip git -y
sudo yum install httpd -y
sleep 10
sudo yum install tree vim python27 atop jq wget curl python-pip git php7.0 -y
sleep 10
