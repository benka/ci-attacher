#!/bin/bash

echo "--------------------------------"
echo "Available updates:"
sudo /usr/lib/update-notifier/apt-check --human-readable
echo "--------------------------------"
echo "UPDATE:"
sudo apt-get -y update
echo "--------------------------------"
echo "INSTALL:"
sudo apt-get -y install
echo "--------------------------------"
echo "UPGRADE:"
sudo apt-get -y upgrade
echo "--------------------------------"
echo "AUTO REMOVE:"
sudo apt-get -y autoremove
