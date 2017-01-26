#!/bin/bash

set -e

. /var/go/.bashrc
. $HOME/.corespring-scripts/go-build-scripts/common/env-check.sh 7
. $(rvm 2.2.4 do rvm env --path)

GIT=$1
BRANCH=$2
BASENAME=$3
FORCE=$4

echo "> GIT: $GIT, BRANCH: $BRANCH, BASENAME: $BASENAME"

cbt artifact-mk-from-git \
--git=$GIT \
--branch=$BRANCH \
--cmd="play universal:packageZipTarball" \
--artifact="target/universal/$BASENAME-(.*).tgz" \
--force=$FORCE
