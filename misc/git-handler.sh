#!/bin/bash
clear
echo ""
echo "### git-handler v1.1 ###"
echo ""
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

# Checking if GIT repository was provided
if [ "$repo" == "" ] ; then
	echo "Please provide the following arguments:"
	echo "---------------------------------------"
	echo " -r, --repo [mandatory]: git repository"
	echo " -d, --dir [optional]: directory to clone git repository"
	echo " -b, --branch [optional, default: master]: branch to check out (and pull from)"
	echo ""
	exit 1
fi

# Checking if branch was provided, 
# otherwise setting it to default: master
if [ "$branch" == "" ] ; then
	branch=master
fi

# Getting directory name in case it was not supplied
if [ "$dir" == "" ] ; then
  dir=$(echo $repo | sed 's|^.*\/||' | sed 's|.git||')
  echo "dir: $dir"
fi 


echo "REPO: $repo"
echo "DIR: $dir"
echo "BRANCH: $branch"


# Cloning GIT repo
git clone $repo $dir > /dev/null 2>&1
success=$?

if [ "$success" != "0" ] ; then
  echo "Repository is already cloned"
fi


# Enter repo dir
cd $dir
# Checkout and pull branch
git checkout $branch
git pull origin $branch

