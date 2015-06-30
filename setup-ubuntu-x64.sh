#!/bin/bash

# "echo 'foreign-architecture i386' > /etc/dpkg/dpkg.cfg.d/multiarch"
apt-get update
apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 curl zip

BASE_DIR=`pwd`
TOOLS_DIR=$BASE_DIR/tools

rm -rf $TOOLS_DIR
mkdir -p $TOOLS_DIR/nanopb
curl -sL http://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.3-linux-x86.tar.gz | tar xz -C $TOOLS_DIR/nanopb --strip-components 1
