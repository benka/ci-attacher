#!/bin/bash
for i in "$@"
do
	case $i in
	    -r=*|--repo=*)
	    repo="${i#*=}"
	    shift # past argument=value
	    ;;
	    -d=*|--dir=*)
	    dir="${i#*=}"
	    shift # past argument=value
	    ;;
	    -b=*|--branch=*)
	    branch="${i#*=}"
	    shift # past argument=value
	    ;;
	    *)
	            # unknown option
	    ;;
	esac
done

echo "REPO: $repo"
echo "DIR: $dir"
echo "BRANCH: $branch"


# Cloning GIT repo
git clone $repo $dir > /dev/null 2>&1
success=$?
if [ $success -neq 0 ] ; then
  echo "Repository is already cloned"
fi

# Getting directory name in case it was not supplied
if [ "$dir" == "" ] ; then
  dir=$(echo $repo | sed 's|^.*\/||' | sed 's|.git||')
  echo "dir: $dir"
fi 

# Enter repo dir
cd $dir
# Checkout and pull branch
git checkout $branch
git pull origin $branch

