#!/bin/sh

PLATFORM=particle
BASE_DIR=`pwd`
DOWNLOAD_DIR=$BASE_DIR/downloads
TOOLS_DIR=$BASE_DIR/tools
BUILD_DIR=$BASE_DIR/build/$PLATFORM
SRC_DIR=$BUILD_DIR/firmware

echo "building for $PLATFORM"
echo "clean"
rm -rf $BUILD_DIR

mkdir -p $SRC_DIR

echo "copying main headers"
cp $PLATFORM/spark.json $BUILD_DIR/
cp $PLATFORM/tentacle-build.h $SRC_DIR/
cp $PLATFORM/tentacle-build.cpp $SRC_DIR/

echo "copying examples"
cp -r $PLATFORM/examples $BUILD_DIR/examples

echo "copying projects"
cp -r $DOWNLOAD_DIR/* $SRC_DIR

echo "Building tentacle-pseudopod"
cd $SRC_DIR/tentacle-pseudopod
cp $SRC_DIR/tentacle-protocol-buffer/tentacle-message.proto .
rm -f *.pb*
$TOOLS_DIR/nanopb/generator-bin/protoc --nanopb_out=. tentacle-message.proto
