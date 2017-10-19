#!/bin/bash
sudo yum update -y
sudo yum install epel-release -y
sudo yum update -y
sudo yum install tree vim python27 atop jq wget curl python27-pip git docker -y
sudo pip install awscli -y
sudo pip install --upgrade pip -y
sudo pip install ansible -y
if [[ $(cat /etc/*-release | grep -i [a]mazon | head -1 | awk -F "=" '{print $2}' | sed -e 's/"//g') == "Amazon Linux AMI"]]
		sudo yum localinstall https://packages.chef.io/files/stable/chef/13.5.3/el/6/chef-13.5.3-1.el6.x86_64.rpm -y
fi
cat << _EOF_ >> /etc/ecs/ecs.config
ECS_LOGLEVEL=debug
ECS_CLUSTER=lincy-test-cluster
ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1m
ECS_DISABLE_IMAGE_CLEANUP=false
ECS_IMAGE_CLEANUP_INTERVAL=3h
ECS_NUM_IMAGES_DELETE_PER_CYCLE=1
ECS_INSTANCE_ATTRIBUTES={"server.type": "Lincy-ecs-webserver"}
_EOF_

service docker status | egrep 'docker dead but subsys locked' && \

{ kill -9 $(ps aux | awk '/[d]ocker/ {print $2 }'| xargs) && \

sudo service docker restart; } || \

{ service docker status | egrep '[a]ctive|[r]unning' || \

service docker restart; }

ps aux | awk ' /[e]cs/ { print $2 }'|xargs sudo kill

start ecs

docker ps| grep [a]ws || echo "ECS not running"

ngcount=`aws ecs describe-services --cluster lincy-test-cluster --service Lincy-ecs-webserver --query 'services[*].runningCount' --output text`
echo $((ngcount+=1))
aws ecs update-service --cluster lincy-test-cluster --service Lincy-ecs-webserver --desired-count $ngcount
