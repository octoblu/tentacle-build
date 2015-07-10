#!/bin/bash
set -e
PLATFORM=particle
BASE_DIR=`pwd`
DEPLOY_DIR=$BASE_DIR/deploy/$PLATFORM

echo "deploying for $PLATFORM"
cd $DEPLOY_DIR
git add .
git commit -a -m "travis, constructing the TERRIFYING TENTACLE for $PLATFORM"
git push
