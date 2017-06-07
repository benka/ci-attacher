#!/bin/bash
clear
echo ""
echo "### git-handler v1.4"
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
	    -h=*|--homedir=*)
	    homedir="${i#*=}"
	    shift # past argument=value
	    ;;
	    --remote_name=*)
	    remote_name="${i#*=}"
	    shift # past argument=value
	    ;;
	    --remote_url=*)
	    remote_url="${i#*=}"
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
	echo " -h, --homedir [optional, default: .]: home path to home /or working directory"
	echo " --remote_name [optional, default: none] when used, script add the specified remote_name and remote_url"
	echo " --remote_url [optional, default: none] use with remote_name"
	echo ""
	exit 1
fi

# Checking home / working directory
# otherwise setting it to default: .
if [ "$homedir" == "" ] ; then
	homedir="."
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

if [ "$remote_name" == "" ] ; then
	remote_url=""
elif [ "$remote_name" != "" ] && [ "$remote_url" == "" ] ; then
	remote_name=""
fi

echo "---------------------------"
echo "REPO: $repo"
echo "DIR: $dir"
echo "HOMEDIR: $homedir"
echo "BRANCH: $branch"
echo "REMOTE_NAME: $remote_name"
echo "REMOTE_URL: $remote_url"
echo "---------------------------"

# Changing to HOMEDIR
mkdir -p $homedir && cd $_

# Cloning GIT repo
echo "currently in dir $(pwd)"
echo "git clone $repo $dir"
git clone $repo $dir > /dev/null 2>&1
clone_success=$?

if [ "$clone_success" != "0" ] ; then
  echo "Repository is already cloned"
fi

# Enter repo dir
cd $dir
echo "currently in dir (after clone) $(pwd)"

# Checkout and pull branch
git fetch origin
git checkout $branch
git reset --hard && git clean -df
git pull origin $branch

if [ "$remote_name" != "" ] ; then
	# Remove and Create git-remote
	git remote remove $remote_name > /dev/null 2>&1
	git remote add $remote_name $remote_url
	remote_success=$?
	if [ "$remote_success" != "0" ] ; then
		echo "Error with creating git remote"
	fi
fi
