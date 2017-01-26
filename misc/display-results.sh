done="Done, without errors."
#echo $done
exit=0

logfile=$1

if [ -e "$logfile" ]; then

    echo "------------------------------"
    echo "DISPLAY LOGS"
    echo "[$logfile]"
    echo "------------------------------"
    if grep -q "Done, without errors." $logfile; then
        echo $done
    else
        cat $logfile
        $exit=1
    fi
    echo "------------------------------"
    echo "------------------------------"
else 
   echo "Log does not exist [$logfile]"
fi    

if [ $exit -eq 1 ]; then
  exit 1
fi
