#!/bin/bash

set -e

. /var/go/.bashrc
. $HOME/.corespring-scripts/go-build-scripts/common/env-check.sh 7
. $(rvm 2.2.4 do rvm env --path)

GIT=$1
BRANCH=$2

echo "> GIT: $GIT, BRANCH: $BRANCH"

cbt build-from-git \
--git=$GIT \
--branch=$BRANCH \
--cmd="play release"
