#!/bin/sh
#In order to use this, you need particle-cli
#npm install -g particle-cli
PLATFORM=particle
BASE_DIR=`pwd`
BUILD_DIR=$BASE_DIR/build/$PLATFORM
SRC_DIR=$BUILD_DIR/firmware
BIN_DIR=$BUILD_DIR/bin

echo "Compiling locally for testing.\n\n"
rm -rf $BIN_DIR
mkdir -p $BIN_DIR

cd $BIN_DIR
particle compile photon $BASE_DIR/$PLATFORM/examples/local-compile/local-compile.ino $SRC_DIR/*/*.* $SRC_DIR/*.*
mv *.bin tentacle-firmware.bin

echo "\n\nTentacle built!"
