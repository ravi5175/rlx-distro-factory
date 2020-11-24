#!/bin/bash

set -e

MUSL_SRC_FLDR="musl-$MUSL_VERSION"

RLX_DOWNLOAD "http://www.musl-libc.org/releases/$MUSL_SRC_FLDR.tar.gz"

RLX_EXTRACT $MUSL_SRC_FLDR.tar.gz

cd $RLX_BUILD_DIR/$MUSL_SRC_FLDR

./configure \
	CROSS_COMPILE=${RLX_TGT}- \
	--prefix=/ \
	--target=${RLX_TGT}
	
make
DESTDIR=${RLX}/cross-tools/${RLX_TGT} make install
