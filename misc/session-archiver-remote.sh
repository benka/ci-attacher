#!/bin/bash

# ###################
# ENV VARS
echo "#user: [$db_user]"
echo "#pass: [$db_password]"
echo "#db_session: [$db_session]"
echo "#db_session_archive: [$db_session_archive]"
echo "#period: [$period]"
echo "#planname: [$GO_PIPELINE_NAME]"
echo "#buildnumber: [$GO_PIPELINE_COUNTER]"
echo "date=$(date '+%Y-%m-%dT%H:%M%z')"
export log=session-archiver-$GO_PIPELINE_NAME-$GO_PIPELINE_COUNTER.log
echo "#log: [$log]"
echo "#ciURL: [$ciURL]"
#echo "#AUTOMATOR_PASSWORD: [$AUTOMATOR_PASSWORD]"
echo "#AUTOMATOR_USER: [$AUTOMATOR_USER]" 
echo "#stage_name: [$stage_name]"

# ###################
# GIT CLONE SESSION-ARCHIVER

cd ~
echo "#pwd: [$(pwd)]"

git clone git@github.com:corespring/session-archiver.git
cd session-archiver
cp index.js index.js.bak
cat index.js.bak | sed 's/var batchSize = 50/var batchSize = 10000/' > index.js
npm install

echo $date > $log

# ###################
# RUN SESSION ARCHIVER
echo "node index.js --db mongodb://$db_user:$db_password@$db_session --archive mongodb://$db_user:$db_password@$db_session_archive $period" | tee -a $log
node index.js --db mongodb://$db_user:$db_password@$db_session --archive mongodb://$db_user:$db_password@$db_session_archive $period | tee -a $log

# ###################
# AWS S3 COPY LOG
echo "aws s3 cp ./$log s3://corespring-session-archiver/" | tee -a $log
aws s3 cp ./$log s3://corespring-session-archiver/

# ###################
# GIT CLONE CI-SCRIPTS
git clone git@github.com:benka/ci-scripts.git
sudo chmod +x ci-scripts/misc/ci-trigger.sh
./ci-scripts/misc/ci-trigger.sh

# ###################
# TURN OFF EC2
poweroff
