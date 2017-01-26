#!/bin/bash
set -e

. /var/go/.bashrc
. $HOME/.corespring-scripts/go-build-scripts/common/env-check.sh 7
. $(rvm 2.2.4 do rvm env --path)

GIT=$1
BRANCH=$2
HEROKU_APP=$3
FORCE=$4

echo "> GIT: $GIT, BRANCH: $BRANCH, HEROKU_APP: $HEROKU_APP, FORCE: $FORCE"

cbt artifact-deploy-from-branch \
--git=$GIT \
--branch=$BRANCH \
--heroku-app=$HEROKU_APP \
--platform=jdk-1.7 \
--force=$FORCE
