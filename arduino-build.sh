#!/bin/bash
BASE_DIR=`pwd`
TOOLS_DIR=$BASE_DIR/tools
BUILD_DIR=$BASE_DIR/build
SRC_DIR=$BASE_DIR/build/src

echo "Clean"

rm -rf $BASE_DIR/build
mkdir -p $BUILD_DIR

echo "Copy h & cpp"

cp -r examples $BUILD_DIR/
cp library.properties $BUILD_DIR/
cp tentacle-build.h $SRC_DIR/
cp tentacle-build.cpp $SRC_DIR/

echo "Installing tools"

rm -rf $TOOLS_DIR
mkdir -p $TOOLS_DIR/nanopb
curl -sL http://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.3-linux-x86.tar.gz | tar xz -C $TOOLS_DIR/nanopb --strip-components 1

echo "Downloading projects"

mkdir -p $SRC_DIR/arduino-nanopb
curl -sL https://github.com/octoblu/arduino-nanopb/archive/master.tar.gz | tar xz -C $SRC_DIR/arduino-nanopb --strip-components 1

mkdir -p $SRC_DIR/tentacle
curl -sL https://github.com/octoblu/tentacle/archive/master.tar.gz | tar xz -C $SRC_DIR/tentacle --strip-components 1

mkdir -p $SRC_DIR/tentacle-arduino
curl -sL https://github.com/octoblu/tentacle-arduino/archive/master.tar.gz | tar xz -C $SRC_DIR/tentacle-arduino --strip-components 1

mkdir -p $SRC_DIR/tentacle-pseudopod
curl -sL https://github.com/octoblu/tentacle-pseudopod/archive/master.tar.gz | tar xz -C $SRC_DIR/tentacle-pseudopod --strip-components 1

mkdir -p $SRC_DIR/tentacle-protocol-buffer
curl -sL https://github.com/octoblu/tentacle-protocol-buffer/archive/master.tar.gz | tar xz -C $SRC_DIR/tentacle-protocol-buffer --strip-components 1

echo "Building tentacle-pseudopod"
cd $SRC_DIR/tentacle-pseudopod
cp $SRC_DIR/tentacle-protocol-buffer/tentacle-message.proto .
rm -f *.pb*
$TOOLS_DIR/nanopb/generator-bin/protoc --nanopb_out=. tentacle-message.proto
cd $BASE_DIR

echo "'Fixing' library paths"
sed -ine 's/"tentacle.h"/"tentacle\/tentacle.h"/' $SRC_DIR/tentacle-arduino/tentacle-arduino.h
sed -ine 's/"proto-buf.hpp"/"tentacle-pseudopod\/proto-buf.hpp"/' $SRC_DIR/tentacle/tentacle.h
sed -ine 's/<pb.h>/"arduino-nanopb\/pb.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-message.pb.h
sed -ine 's/<pb_encode.h>/"arduino-nanopb\/pb_encode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/<pb_decode.h>/"arduino-nanopb\/pb_decode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"pb_arduino_encode.h"/"arduino-nanopb\/pb_arduino_encode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"pb_arduino_decode.h"/"arduino-nanopb\/pb_arduino_decode.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
sed -ine 's/"tentacle.h"/"tentacle\/tentacle.h"/' $SRC_DIR/tentacle-pseudopod/tentacle-pseudopod.h
