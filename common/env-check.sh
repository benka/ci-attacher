#!/bin/bash

echo "---- ENV_CHECK PARAMS (3) ----"
if [ "$1" == 8 ] || [ "$1" == 7 ] ; then
 j=$1
else
 echo "-- ENV_CHECK: no JAVA version param provided: \$1"
 echo "-- ENV_CHECK: setting JAVA to default: JAVA 8"
 j=8
fi

echo "-- ENV_CHECK: \$1: java version [7, default 8]: ($j)"
echo "-- ENV_CHECK: \$2: empty: ($2)"
echo "-- ENV_CHECK: \$3: empty: ($3)"

#set -e
. $HOME/.corespring-scripts/go-build-scripts/common/env-vars.sh $j
. /etc/profile.d/rvm.sh


sudo update-java-alternatives -s java-1.$j.0-openjdk-amd64
sudo service elasticsearch restart

echo "---- ENV CHECK ----"
echo "---- path ----"
echo $PATH
echo "---- shell check ----"
echo $SHELL
echo $0
ps  -ef | grep $$ | grep -v grep
echo "---- end shell sheck ---"

echo "rvm check:"
type rvm | head -n 1

echo "java version"
java -version
echo "JAVA_HOME: $JAVA_HOME"
