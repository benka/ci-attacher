#!/bin/bash

export SBT_OPTS="-Xmx2G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M -Duser.timezone=GMT -XX:+PrintVMOptions"
# why isn't this the default in bamboo
#export LANG=en_US.UTF-8
#export LANGUAGE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

set -e 

. /var/go/.bashrc
. $HOME/.corespring-scripts/go-build-scripts/common/env-check.sh 7 corespring
. $(rvm 2.2.4 do rvm env --path)

GIT=$1
BRANCH=$2
BASENAME=$3

echo "! - force is always true"

FORCE=true

echo "> GIT: $GIT, BRANCH: $BRANCH, BASENAME: $BASENAME, FORCE: $FORCE"

cbt artifact-mk-from-git \
--git=$GIT \
--branch=$BRANCH \
--cmd="play release" \
--artifact="target/universal/$BASENAME-(.*).tgz" \
--force=$FORCE
