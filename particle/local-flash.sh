#!/bin/sh
#In order to use this, you need dfu-util.
# brew install DFU-util openssl

PLATFORM=particle
BASE_DIR=`pwd`
BUILD_DIR=$BASE_DIR/build/$PLATFORM
BIN_DIR=$BUILD_DIR/bin

echo "Flashing the TERRIFYING TENTACLE\n\n"
echo "Remember to hold SETUP and RESET buttons down, then let go of RESET. Hold SETUP until the light blinks yellow"
echo "Read about it http://docs.particle.io/core/modes/ and search for DFU mode for more info.\n\n"
cd $BIN_DIR
sudo particle flash --usb tentacle-firmware.bin

echo "\n\nIf there was a download progress bar above, then it probably flashed, even though it always says it fails at the end."
