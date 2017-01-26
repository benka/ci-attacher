#!/bin/bash

echo "disk space before cleanup"
df -h
echo "-------------------------"
echo "-------------------------"
echo "cleaning up CIO:"
echo "- logs"
echo "- repositories checked out by build plans"
echo "- build artifacts"
echo "- docker images & containers"
echo "- build locks"
cd /var/lib/go-agent/pipelines
rm -rf *
cd ~
echo "-------------------------"
echo "-------------------------"
echo "cleaning up CS-BUILDER:"
echo "- locks"
cd ~/.cs-builder/locks
rm -rf *

echo "- repositories"
cd ~/.cs-builder/repos/corespring
rm -rf *

echo "- slugs"
cd ~/.cs-builder/slugs
rm -rf *

echo "- artifacts"
cd ~/.cs-builder/artifacts
rm -rf *

echo "- binaries"
cd ~/.cs-builder/binaries
rm -rf *

cd ~
echo "-------------------------"
echo "-------------------------"
echo "cleaning up DOCKER:"
echo "- containers"
docker ps -a | awk '{print $1}' | xargs --no-run-if-empty docker rm

echo "- images"
docker images -a | awk '{print $3}' | xargs --no-run-if-empty docker rmi

cd ~
echo "-------------------------"
echo "-------------------------"
echo "SUDO APT AUTOREMOVE:"
sudo apt -y autoremove


cd ~
echo "-------------------------"
echo "-------------------------"
echo "cleaning up BUILD LOCKS:"
mkdir -p $build_selector && cd $_
echo "" > $build_selector

echo "-------------------------"
echo "-------------------------"
echo "disk space after cleanup"
df -h
