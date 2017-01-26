#!/bin/bash

echo "------------------------"
echo "Deploy Selector"
echo "------------------------"

if [ "$deploy_selector" == "" ] ; then
  export deploy_selector=".deploy_selector"
fi

echo "vvvvvvvvvvvvvvvvvvvvvvvv"
cat ~/$deploy_selector/$deploy_selector
echo "^^^^^^^^^^^^^^^^^^^^^^^^"

if [ "$deploy_selector_action" == "" ] || [ "$deploy_selector_action" == "clean" ] ; then
  echo "#CLEANUP: [$deploy_selector]"  
  mkdir -p ~/$deploy_selector
  echo "" > ~/$deploy_selector/$deploy_selector
  exit 0
fi

if [ "$deploy_env" == "" ] || [ "$deploy_project" == "" ] ; then 
  echo "#STARTUP: missing env vars \$deploy_env: [ac|qa:$deploy_env]"
  echo "#STARTUP: missing env vars \$deploy_project: [ac|pe:$deploy_project]"
  exit 1
fi

echo "\$deploy_env: [$deploy_env]"
echo "\$deploy_project: [$deploy_project]"
echo "\$deploy_selector_action [check,lock,clean]: [$deploy_selector_action]"
echo "\$deploy_selector: [$deploy_selector]"

mkdir -p ~/$deploy_selector

if [ "$deploy_selector_action" == "lock" ] ; then
  echo "#LOCK..."
  if [ -e ~/$deploy_selector/$deploy_selector ] ; then
    echo "#LOCK: [$deploy_selector] already exists"
    
    res=$(grep "$deploy_project $deploy_env" < ~/$deploy_selector/$deploy_selector)
    if [ ! -n "$res" ] ; then
      echo "#LOCK: [$deploy_project@$deploy_env] NOT LOCKED for a BUILD"
      env=-
    else
      env=$(echo $res | awk '{print $2}')
      proj=$(echo $res | awk '{print $1}')
      echo "#LOCK: [$proj @ $env] found"
      echo "#LOCK: comparing..."
      echo "#LOCK: [$deploy_project : $proj]..."
      echo "#LOCK: [$deploy_env : $env] ..."
      if [ "$env" == "$deploy_env" ] ; then 
        echo "#LOCK: [$env] ALREADY LOCKED for [$proj]"
        exit 1
      fi 
    fi
  fi

  echo "#LOCK: creating LOCK for [$deploy_project $deploy_env] in [~/$deploy_selector/$deploy_selector]"
  echo "$deploy_project $deploy_env" >> ~/$deploy_selector/$deploy_selector
  exit 0
fi

if [ "$deploy_selector_action" == "check" ] ; then
  echo "#CHECK..."
  if [ -e ~/$deploy_selector/$deploy_selector ] ; then
    echo "#CHECK: [$deploy_selector] already exists"

    res=$(grep "$deploy_project $deploy_env" < ~/$deploy_selector/$deploy_selector)
    if [ ! -n "$res" ]; then
      echo "#CHECK: [$deploy_project@$deploy_env] NO LOCKS for the requested BUILD"
    else
      env=$(echo $res | awk '{print $2}')
      proj=$(echo $res | awk '{print $1}')
      echo "#CHECK: [$proj@$env] found"
      echo "#CHECK: comparing..."
      echo "#CHECK: [$deploy_project:$proj]..."
      echo "#CHECK: [$deploy_env:$env] ..."

      if [ "$env" == "$deploy_env" ] && [ "$proj" == "$deploy_project" ] ; then
        echo "#CHECK: LOCK [$proj@$env] found for the deploy!"
        echo "#CHECK: removing [$env] from LOCK [~/$deploy_selector/$deploy_selector]"
        sed -i "/$deploy_project $deploy_env/d" ~/$deploy_selector/$deploy_selector
        echo "#CHECK: SCHEDULING the deploy [$proj@$env]"
        exit 0
      fi
    fi
  fi
  
  echo "#CHECK: dropping deploy request [$deploy_project@$deploy_env]"i
  exit 1
fi
