#!/bin/bash

if [ "$#" -ne "2" ]; then
  echo "Usage: bump.sh gitref deploy"
  echo "  gitref must be an indexed_gzip commit, tag, or branch"
  echo "  deploy must be either 0 or 1"
  exit 1
fi

tmp=`dirname $0`
pushd $tmp > /dev/null
thisdir=`pwd`
popd > /dev/null

pushd indexed_gzip > /dev/null
git pull origin master
popd > /dev/null

gitref=$1
deploy=$2

sed -ie "s/BUILD_COMMIT=.*$/BUILD_COMMIT=$gitref/g"   .travis.yml
sed -ie "s/BUILD_COMMIT: .*$/BUILD_COMMIT: $gitref/g"  appveyor.yml

if [ "$deploy" == "1" ]; then
    sed -ie "s/DEPLOY=.*$/DEPLOY=1/g"   .travis.yml
    sed -ie "s/DEPLOY: .*$/DEPLOY: 1/g"  appveyor.yml
else
    sed -ie "s/DEPLOY=.*$/DEPLOY=0/g"   .travis.yml
    sed -ie "s/DEPLOY: .*$/DEPLOY: 0/g"  appveyor.yml
fi
