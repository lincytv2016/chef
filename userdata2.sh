#!/bin/bash
sudo yum update -y
#sudo yum install epel-release -y
#sudo yum update -y
#sudo yum install tree vim python27 atop jq wget curl python-pip git -y
sudo yum install tree vim python27 atop jq wget curl python-pip git -y
sudo pip install pip --upgrade
sudo pip install awscli
sudo yum install httpd php* -y
