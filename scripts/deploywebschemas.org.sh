#!/bin/bash
set -e
set -u

#Deployment for the schema.org site

function usage {
    echo "usage: $(basename $0) -e -m"
	echo "-e bypasses exercise of site step"
	echo "-m bypasses migrate traffic to new version step"
}

EXE=""
MIG=""
while getopts 'em' OPTION; do
  case "$OPTION" in
    e)
      EXE="-e"
    ;;
    m)
        MIG="-m"
    ;;
    ?)
        usage
        exit 1
    ;;
  esac
done

if [ ! -d ./scripts ]
then
    echo "No valid scripts directory! Aborting"
	exit 1
fi

if [ ! -d sdopythonapp ]
then
    echo "No 'sdopythonapp' directory here aboorting!"
    exit 1
fi

if [ ! -x sdopythonapp/runscripts/runpythondeploy.sh ]
then
    echo "No 'sdopythonapp/runscripts' directory here aboorting!"
    exit 1
fi

git submodule update --remote

export ROBOTSBLOCK="YES" #ensure we end up with a blocking robots.txtS
sdopythonapp/runscripts/runpythondeploy.sh $EXE $MIG -p webschemas-g -y webschemas.yaml

