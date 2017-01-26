#!/bin/bash

echo "---- ENV_VARS ----"
#echo "SAUCE_ACCESS_KEY: $SAUCE_ACCESS_KEY"
echo "SAUCE_USERNAME: $SAUCE_USERNAME"
echo "CONTAINER_HOST_URL: $CONTAINER_HOST_URL" 
#echo "CONTAINER_MONGO_URI: $CONTAINER_MONGO_URI"
echo "RIG_URL: $RIG_URL"
#echo "CS_API_MONGO_URI: $CS_API_MONGO_URI"
#echo "AUTOMATOR_PASSWORD: $AUTOMATOR_PASSWORD"
echo "AUTOMATOR_USER: $AUTOMATOR_USER" 
echo "GO_PIPELINE_NAME: $GO_PIPELINE_NAME"
echo "GO_PIPELINE_COUNTER: $GO_PIPELINE_COUNTER"
echo "------------------"

if [ "$log_file" == "" ] ; then
  $log_file="ci_trigger"
fi

postfix="$GO_PIPELINE_NAME-$GO_PIPELINE_COUNTER"
logfile="$log_file-$postfix.log"
echo "creating logfile... [$logfile]"
touch $logfile

echo "------------------"
echo "ciURL: $ciURL"
echo "stripping \"HTTP(S)://\""
ciURL=$(echo $ciURL | sed 's/https\?:\/\///')
echo "ciURL [stripped]: $ciURL"
echo "------------------"
echo " "
echo " "
echo "------------------"
if [ "$cmd" != "" ] ; then
 echo "running CMD..."
 echo "$cmd"
 echo "logging to [\$log_file]: $logfile"
 $(echo $cmd) | tee $logfile
else
 echo "no CMD [\$cmd] provided this time..."
fi
echo "------------------"
echo "sleep"
sleep 20
echo "------------------"
echo "Calling CI API to start PIPELINE [$GO_PIPELINE_NAME]".
if [ "$stage_name" != "" ] ; then
 echo "... with STAGE [$stage_name]" 
 echo "... at COUNTER [$GO_PIPELINE_COUNTER]"
 echo "curl -H \"Confirm: true\" --data \"\" http://$AUTOMATOR_USER:$AUTOMATOR_PASSWORD@$ciURL/go/run/$GO_PIPELINE_NAME/$GO_PIPELINE_COUNTER/$stage_name | tee $logfile"

 curl -H "Confirm: true" --data "" http://$AUTOMATOR_USER:$AUTOMATOR_PASSWORD@$ciURL/go/run/$GO_PIPELINE_NAME/$GO_PIPELINE_COUNTER/$stage_name | tee $logfile
else 
 echo "curl -X POST -H \"Confirm: true\" -u \"$AUTOMATOR_USER:$AUTOMATOR_PASSWORD\" http://$ciURL/go/api/pipelines/$GO_PIPELINE_NAME/schedule | tee $logfile"

 curl -X POST -H "Confirm: true" -u "$AUTOMATOR_USER:$AUTOMATOR_PASSWORD" http://$ciURL/go/api/pipelines/$GO_PIPELINE_NAME/schedule | tee $logfile
fi

