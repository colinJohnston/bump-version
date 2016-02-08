#!/usr/bin/env bash
# ------------------
# bump-version.sh - update the version property in package.yaml
#
# usage:
#   ./bump-version.sh major          : x.y.z -> x+1.0.0 ; use for breaking changes
#   ./bump-version.sh minor          : x.y.z -> x.y+1.0 ; use for new backward compatible features
#   ./bump-version.sh <no arguments> : x.y.z -> x.y.z+1 ; use for bugfixes or minor updates
# ------------------

PWD=`pwd`
FILE_NAME=package.yaml
VERSION=""
MAJOR=0
MINOR=0
PACKAGE=0

function read_version {
	VERSION=`cat $PWD/$FILE_NAME | perl -ne 'if (m/^version(\s?)+:(\s?)+(\d+\.\d+\.\d+)/) { print "$3" }'`
	MAJOR=`echo $VERSION | perl -ne 'if (m/(\d+)\.(\d+)\.(\d+)/) { print "$1" }'`
	MINOR=`echo $VERSION | perl -ne 'if (m/(\d+)\.(\d+)\.(\d+)/) { print "$2" }'`
	PACKAGE=`echo $VERSION | perl -ne 'if (m/(\d+)\.(\d+)\.(\d+)/) { print "$3" }'`
}

function write_version {
	perl -pi -e "s/^version(\s?)+:(\s?)+\d+\.\d+\.\d+/version: $MAJOR.$MINOR.$PACKAGE/" $PWD/$FILE_NAME
}

read_version

if [ "$VERSION" == "" ]
then
	echo "ERROR: couldn't parse version string from $PWD/$FILE_NAME"
	exit 1
fi

if [ "$1" == "major" ]
then
	let MAJOR+=1
	MINOR=0
	PACKAGE=0
elif [ "$1" == "minor" ]
then
	let MINOR+=1
	PACKAGE=0
else
	let PACKAGE+=1
fi

echo "updating $VERSION -> $MAJOR.$MINOR.$PACKAGE" 

write_version

echo "done"
