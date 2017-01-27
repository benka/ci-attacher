#!/bin/bash

# ###################
# ENV VARS
export log="~/$GO_PIPELINE_NAME-$GO_PIPELINE_COUNTER.log"

echo "#user: [$db_user]" | tee -a $log
echo "#pass: [$db_password]" | tee -a $log
echo "#db_session: [$db_session]" | tee -a $log
echo "#db_session_archive: [$db_session_archive]" | tee -a $log
echo "#period: [$period]" | tee -a $log
echo "#planname: [$GO_PIPELINE_NAME]" | tee -a $log
echo "#buildnumber: [$GO_PIPELINE_COUNTER]" | tee -a $log
date '+%Y-%m-%dT%H:%M%z' | tee -a $log
echo "#log: [$log]" | tee -a $log
echo "#ciURL: [$ciURL]" | tee -a $log
echo "#AUTOMATOR_PASSWORD: [$AUTOMATOR_PASSWORD]" | tee -a $log
echo "#AUTOMATOR_USER: [$AUTOMATOR_USER]"  | tee -a $log
echo "#stage_name: [$stage_name]" | tee -a $log

# ###################
# GIT CLONE SESSION-ARCHIVER
cd ~
echo "#pwd: [$(pwd)]" | tee -a $log
git clone git@github.com:corespring/session-archiver.git | tee -a $log
cd session-archiver
cp index.js index.js.bak
cat index.js.bak | sed 's/var batchSize = 50/var batchSize = 10000/' > index.js
npm install | tee -a $log

# ###################
# RUN SESSION ARCHIVER
echo "node index.js --db mongodb://$db_user:$db_password@$db_session --archive mongodb://$db_user:$db_password@$db_session_archive --months $period" | tee -a $log
node index.js --db mongodb://$db_user:$db_password@$db_session --archive mongodb://$db_user:$db_password@$db_session_archive --months $period | tee -a $log

# ###################
# AWS S3 COPY LOG
echo "aws s3 cp ./$log s3://corespring-session-archiver/" | tee -a $log
aws s3 cp ./$log s3://corespring-session-archiver/ | tee -a $log

# ###################
# GIT CLONE CI-SCRIPTS
cd ~
git clone git@github.com:benka/ci-scripts.git | tee -a $log
sudo chmod +x ./ci-scripts/misc/ci-trigger.sh
./ci-scripts/misc/ci-trigger.sh | tee -a $log

# ###################
# TURN OFF EC2
poweroff | tee -a $log
