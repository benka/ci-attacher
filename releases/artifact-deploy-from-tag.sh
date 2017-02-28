#!/bin/bash

set -e 

. /var/go/.bashrc
. $HOME/.corespring-scripts/go-build-scripts/common/env-check.sh 7 corespring
. $(rvm 2.2.4 do rvm env --path)

GIT=$1
BRANCH=$2
TAG=$3
HEROKU_APP=$4
FORCE=$5

echo "> GIT: $GIT, BRANCH: $BRANCH, TAG: $TAG, HEROKU_APP: $HEROKU_APP, FORCE: $FORCE"

cbt artifact-deploy-from-tag \
--git=$GIT \
--branch=$BRANCH \
--tag=$TAG \
--heroku-app=$HEROKU_APP \
--platform=jdk-1.7 \
--force=$FORCE
