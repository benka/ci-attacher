#!/bin/bash

if [ "$1" == "" ] ; then
  echo "project_name [\$1] not found..."
  echo "please run this script with PROJECT_NAME argument, e.g.:"
  echo "./ci-image-backup.sh your_project_name"
  echo "exiting now..."
  exit 1
fi

date=$(date +%Y-%m-%d_%H%M)
echo $date

instanceId=$(aws ec2 describe-instances --filters Name=tag-value,Values=$1 Name=instance-state-name,Values=running | grep InstanceId | awk '{print $2}' | tr -d '"' | tr -d ',')
project=cut -d':' -f1 <<< $1

echo $instanceId
if [ "$instanceId" == "" ] ; then
  echo "No EC2 instances found with the \"Name: $1\"..."
  echo "exiting now..."
  exit 1
fi

aws ec2 create-image --instance-id $instanceId --name "$project GoCD backup $date" --no-reboot > ami-id.log

