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
cp $PLATFORM/tentacle-particle.h $SRC_DIR/
cp $PLATFORM/tentacle-particle.cpp $SRC_DIR/

echo "copying examples"
cp -r $PLATFORM/examples $SRC_DIR/examples

echo "copying projects"
cp -r $DOWNLOAD_DIR/* $SRC_DIR

echo "Building tentacle-pseudopod"
cd $SRC_DIR/tentacle-pseudopod
cp $SRC_DIR/tentacle-protocol-buffer/tentacle-message.proto .
rm -f *.pb*
$TOOLS_DIR/nanopb/generator-bin/protoc --nanopb_out=. tentacle-message.proto

cd $BASE_DIR
echo "'Fixing' library paths"
sed -ine 's/"tentacle.h"/"tentacle-particle\/tentacle\/tentacle.h"/' $SRC_DIR/tentacle-arduino/tentacle-arduino.h
sed -ine 's/"proto-buf.h"/"tentacle-particle\/tentacle-pseudopod\/proto-buf.h"/' $SRC_DIR/tentacle/tentacle.h
sed -ine 's/<pb.h>/"arduino-nanopb\/pb.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-message.pb.h
sed -ine 's/"pb_encode.h"/"tentacle-particle\/arduino-nanopb\/pb_encode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"pb_decode.h"/"tentacle-particle\/arduino-nanopb\/pb_decode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"pb_arduino_encode.h"/"tentacle-particle\/arduino-nanopb\/pb_arduino_encode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"pb_arduino_decode.h"/"tentacle-particle\/arduino-nanopb\/pb_arduino_decode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"tentacle.h"/"tentacle-particle\/tentacle\/tentacle.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
