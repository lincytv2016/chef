#!/bin/bash
sudo yum update -y
#sudo yum install epel-release -y
#sudo yum update -y
#sudo yum install tree vim python27 atop jq wget curl python-pip git -y
sudo yum install httpd -y
sleep 10
sudo yum install tree vim python27 atop jq wget curl python-pip git php -y
sleep 10
sudo chkconfig httpd on
sudo service httpd restart
sleep 10
sudo yum install mysql-server -y
sudo yum install php php-mysql -y
