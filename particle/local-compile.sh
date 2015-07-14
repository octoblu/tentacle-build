#!/bin/sh
#In order to use this, you need particle-cli
#npm install -g particle-cli
PLATFORM=particle
BASE_DIR=`pwd`
BUILD_DIR=$BASE_DIR/build/$PLATFORM
LIB_DIR=$BASE_DIR/deploy/$PLATFORM/firmware
BIN_DIR=$BUILD_DIR/bin
SRC_FILE=$BASE_DIR/$PLATFORM/examples/tentacle-particle/tentacle-particle.ino

echo "Compiling locally for testing.\n\n"
rm -rf $BIN_DIR
mkdir -p $BIN_DIR

cd $BIN_DIR
particle compile photon $SRC_FILE $LIB_DIR/*.h $LIB_DIR/*.cpp

mv *.bin tentacle-firmware.bin

echo "\n\nTentacle built!"
