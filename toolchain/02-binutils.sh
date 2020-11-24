#!/bin/bash


set -e

BINUTILS_SRC_FLDR="binutils-$BINUTILS_VERSION"

RLX_DOWNLOAD "http://ftp.gnu.org/gnu/binutils/$BINUTILS_SRC_FLDR.tar.xz"

RLX_EXTRACT $BINUTILS_SRC_FLDR.tar.xz

cd $RLX_BUILD_DIR/$BINUTILS_SRC_FLDR

mkdir -pv build && cd build

../configure \
	--prefix=${RLX}/cross-tools \
	--target=${RLX_TGT} \
	--with-sysroot=${RLX}/cross-tools/${RLX_TGT} \
	--disable-nls \
	--disable-multilib
	
make configure-host
make
make install
