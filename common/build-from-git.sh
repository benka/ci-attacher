#!/bin/bash

set -e 

. /var/go/.bashrc
. $HOME/.corespring-scripts/go-build-scripts/common/env-check.sh 7
. /etc/profile.d/rvm.sh
. $(rvm 2.2.4 do rvm env --path)

GIT=$1
BRANCH=$2
CMD=$3

echo "> GIT: $GIT, BRANCH: $BRANCH, CMD: $CMD"

cbt build-from-git \
--git=$GIT \
--branch=$BRANCH \
--cmd="$CMD"
