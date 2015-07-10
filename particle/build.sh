#!/bin/sh

PLATFORM=particle
BASE_DIR=`pwd`
DOWNLOAD_DIR=$BASE_DIR/downloads
TOOLS_DIR=$BASE_DIR/tools
BUILD_DIR=$BASE_DIR/build/$PLATFORM
SRC_DIR=$BUILD_DIR/firmware

DEPLOY_DIR=$BASE_DIR/deploy/$PLATFORM
DEPLOY_SRC_DIR=$DEPLOY_DIR/firmware

echo "building for $PLATFORM"
echo "clean"
# rm -rf $BUILD_DIR
rm -rf $DEPLOY_DIR

mkdir -p $SRC_DIR
mkdir -p $DEPLOY_SRC_DIR

echo "copying main headers"
cp $PLATFORM/spark.json $DEPLOY_DIR/
cp $PLATFORM/tentacle-particle.h $SRC_DIR/
cp $PLATFORM/tentacle-particle.cpp $SRC_DIR/

echo "copying projects"
# cp -r $DOWNLOAD_DIR/* $SRC_DIR

echo "Building tentacle-pseudopod"
# cd $SRC_DIR/tentacle-pseudopod
# cp $SRC_DIR/tentacle-protocol-buffer/tentacle-message.proto .
# rm -f *.pb*
# $TOOLS_DIR/nanopb/generator-bin/protoc --nanopb_out=. tentacle-message.proto

echo "cloning repo for $PLATFORM"
echo git@github.com:octoblu/tentacle-dist-$PLATFORM
git clone git@github.com:octoblu/tentacle-dist-$PLATFORM $DEPLOY_DIR
git config user.name "Travis CI"
git config user.email "sqrt+travis@octoblu.com"

cd $DEPLOY_DIR
rm -rf *.cpp *.h *.hpp *.hne examples/ firmware/ *tentacle* *arduino*

mkdir -p $DEPLOY_SRC_DIR

cd $BASE_DIR
echo "copying examples"
cp -r $PLATFORM/examples $DEPLOY_SRC_DIR/examples

(
  cd $SRC_DIR
  for g in '*.c' '*.h' '*.cpp'; do
    for f in $(find . -iname ${g}); do
      cp $f $DEPLOY_SRC_DIR
    done
  done
  cd $DEPLOY_SRC_DIR
  for f in *.c; do
    mv $f ${f}pp
  done
);

sed -ine 's/<pb.h>/"pb.h"/' $DEPLOY_SRC_DIR/tentacle-message.pb.h


echo "copied new code"
