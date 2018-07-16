#!/bin/bash

#-------------------------------------
# variables
version="0.1"
keyword="error"
logfile=""

#-------------------------------------
# functions
header() {
  echo "Run log parser $version"
}

help() {
  echo "------------------------------------"
  echo "Makes CI pipelines fail when the provided keyword (default='error') is detected in output run logs"
  echo -e "even the command that produced the log completes successfuly\n"
  echo "Usage:"
  echo "./run-log-parser logfile_to_analyse keyword_to_search_for"
  echo -e "\nexiting now...\n"
  exit 1
}


#-------------------------------------
# main
header

if [ "$1" == "" ] ; then
  help
fi

logfile=$1

if [ "$2" == "" ] ; then
  echo ".using default keyword: $keyword"
else 
  keyword=$2
  echo ".using keyword: $keyword"
fi

count=$(grep -c -i $keyword $logfile)

if [ "$count" != "0" ] ; then
  echo ".keyword $keyword found: $count time(s)"
  echo ".failure..."
  exit 1
else
  echo ".keyword $keyword not found"
  echo ".success..."
  exit 0
fi