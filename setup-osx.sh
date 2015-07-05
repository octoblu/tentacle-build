#!/bin/bash

BASE_DIR=`pwd`
TOOLS_DIR=$BASE_DIR/tools

rm -rf $TOOLS_DIR
mkdir -p $TOOLS_DIR/nanopb
curl -sL http://koti.kapsi.fi/~jpa/nanopb/download/nanopb-0.3.3-macosx-x86.tar.gz | tar xz -C $TOOLS_DIR/nanopb --strip-components 1
