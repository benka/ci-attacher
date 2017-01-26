#!/bin/bash
echo "---- ENV_VAR PARAMS (1) ----"
if [ "$1" == 8 ] || [ "$1" == 7 ] ; then
 j=$1
else
 echo "-- ENV_VAR: setting JAVA to default: JAVA 8"
 j=8
fi
echo "-- ENV_VAR: JAVA version: [$j]"

export RVM_BIN="/usr/local/rvm/gems/ruby-2.2.4/bin:"
export PATH=$(echo $PATH | sed "s|$RVM_BIN||" | sed "s|^|$RVM_BIN|")
export PATH=$PATH:/usr/local/heroku/bin
export AWS_ACCESS_KEY=$AWS_AK
export AWS_SECRET_KEY=$AWS_SK
export COMPILE_TIMEOUT=4000
export 'JAVA_OPTS=-Xmx6G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=8G -Xss2M -Duser.timezone=GMT -XX:+PrintVMOptions'
export 'SBT_OPTS=-Xmx6G -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=8G -Xss2M  -Duser.timezone=GMT'
export SBT_SCALA_VERSION=2.10.4
export JAVA_HOME="/usr/lib/jvm/java-$j-openjdk-amd64"
export PATH="$(echo $PATH | sed s/java-8/java-$j/)"
