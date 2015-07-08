#!/bin/sh
BASE_DIR=`pwd`
DOWNLOAD_DIR=$BASE_DIR/downloads
TOOLS_DIR=$BASE_DIR/tools
BUILD_DIR=$BASE_DIR/build

echo "Clean"

rm -rf $BUILD_DIR
rm -rf $DOWNLOAD_DIR

mkdir -p $BUILD_DIR
mkdir -p $DOWNLOAD_DIR


echo "Downloading projects"
mkdir -p $DOWNLOAD_DIR/arduino-nanopb
curl -sL https://github.com/octoblu/arduino-nanopb/archive/master.tar.gz | tar xz -C $DOWNLOAD_DIR/arduino-nanopb --strip-components 1

mkdir -p $DOWNLOAD_DIR/tentacle
curl -sL https://github.com/octoblu/tentacle/archive/master.tar.gz | tar xz -C $DOWNLOAD_DIR/tentacle --strip-components 1

mkdir -p $DOWNLOAD_DIR/tentacle-arduino
curl -sL https://github.com/octoblu/tentacle-arduino/archive/master.tar.gz | tar xz -C $DOWNLOAD_DIR/tentacle-arduino --strip-components 1

mkdir -p $DOWNLOAD_DIR/tentacle-pseudopod
curl -sL https://github.com/octoblu/tentacle-pseudopod/archive/master.tar.gz | tar xz -C $DOWNLOAD_DIR/tentacle-pseudopod --strip-components 1

mkdir -p $DOWNLOAD_DIR/tentacle-protocol-buffer
curl -sL https://github.com/octoblu/tentacle-protocol-buffer/archive/master.tar.gz | tar xz -C $DOWNLOAD_DIR/tentacle-protocol-buffer --strip-components 1

./build-arduino.sh
