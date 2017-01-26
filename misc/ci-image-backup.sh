#!/bin/bash

date=$(date +%Y-%m-%d_%H%M)
echo $date

instanceId=$(aws ec2 describe-instances --filters Name=tag-value,Values=Corespring::GoCD Name=instance-state-name,Values=running | grep InstanceId | awk '{print $2}' | tr -d '"' | tr -d ',')

echo $instanceId

aws ec2 create-image --instance-id $instanceId --name "Corespring GoCD backup $date" --no-reboot > ami-id.log

