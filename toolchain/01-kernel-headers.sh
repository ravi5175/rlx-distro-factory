#!/bin/bash

set -e


KRNL_SRC_FLDR="linux-$KERNEL_VERSION"

RLX_DOWNLOAD "https://www.kernel.org/pub/linux/kernel/v5.x/$KRNL_SRC_FLDR.tar.xz"

RLX_EXTRACT $KRNL_SRC_FLDR.tar.xz

cd $RLX_BUILD_DIR/$KRNL_SRC_FLDR
make mrproper

make ARCH=${RLX_ARCH} headers
find usr/include -name '.*' -delete
rm usr/include/Makefile

mkdir -pv $RLX/cross-tools/${RLX_TGT}/usr/include
cp -rv usr/include/* $RLX/cross-tools/${RLX_TGT}/usr/include/
