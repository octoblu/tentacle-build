#!/bin/bash
set -e
PLATFORM=particle
BASE_DIR=`pwd`
DEPLOY_DIR=$BASE_DIR/deploy/$PLATFORM
BUILD_DIR=$BASE_DIR/build/$PLATFORM

echo "deploying for $PLATFORM"
echo "clean"
rm -rf $DEPLOY_DIR
mkdir -p $DEPLOY_DIR

echo "cloning repo for $PLATFORM"
echo git@github.com:octoblu/tentacle-dist-$PLATFORM
git clone git@github.com:octoblu/tentacle-dist-$PLATFORM $DEPLOY_DIR
git config user.name "Travis CI"
git config user.email "sqrt+travis@octoblu.com"

echo "removing old code"
cd $DEPLOY_DIR
rm -rf *.cpp *.h examples/ firmware/ *tentacle* *arduino*
cp -r $BUILD_DIR/* .
echo "copied new code"
git add .
git commit -a -m "travis, constructing the TERRIFYING TENTACLE for $PLATFORM"
git push


# git add .
# git commit -m "Deploy to GitHub Pages"
#
# # Force push from the current repo's master branch to the remote
# # repo's gh-pages branch. (All previous history on the gh-pages branch
# # will be lost, since we are overwriting it.) We redirect any output to
# # /dev/null to hide any sensitive credential data that might otherwise be exposed.
# git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
