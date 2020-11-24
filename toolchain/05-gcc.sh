#!/bin/bash


set -e

GCC_SRC_FLDR="gcc-$GCC_VERSION"
MPFR_SRC_FLDR="mpfr-$MPFR_VERSION"
MPC_SRC_FLDR="mpc-$MPC_VERSION"
GMP_SRC_FLDR="gmp-$GMP_VERSION"

RLX_DOWNLOAD http://ftp.gnu.org/gnu/gcc/$GCC_SRC_FLDR/$GCC_SRC_FLDR.tar.xz
RLX_DOWNLOAD http://www.mpfr.org/$MPFR_SRC_FLDR/$MPFR_SRC_FLDR.tar.xz
RLX_DOWNLOAD https://ftp.gnu.org/gnu/mpc/$MPC_SRC_FLDR.tar.gz
RLX_DOWNLOAD http://ftp.gnu.org/gnu/gmp/$GMP_SRC_FLDR.tar.xz

RLX_EXTRACT $GCC_SRC_FLDR.tar.xz
# RLX_EXTRACT $GMP_SRC_FLDR.tar.xz
# RLX_EXTRACT $MPFR_SRC_FLDR.tar.xz
# RLX_EXTRACT $MPC_SRC_FLDR.tar.gz

tar -xaf $RLX_SRC_DIR/$GMP_SRC_FLDR.tar.xz -C $RLX_BUILD_DIR/
tar -xaf $RLX_SRC_DIR/$MPFR_SRC_FLDR.tar.xz -C $RLX_BUILD_DIR/
tar -xaf $RLX_SRC_DIR/$MPC_SRC_FLDR.tar.gz -C $RLX_BUILD_DIR/

cd $RLX_BUILD_DIR/$GCC_SRC_FLDR

mv -v ../$MPFR_SRC_FLDR mpfr
mv -v ../$GMP_SRC_FLDR gmp
mv -v ../$MPC_SRC_FLDR mpc


case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' \
            -i.orig gcc/config/i386/t-linux64
    ;;
esac

mkdir -pv build && cd build

../configure \
	--prefix=${RLX}/cross-tools \
	--build=${RLX_HOST} \
	--host=${RLX_HOST} \
	--target=${RLX_TGT} \
	--with-sysroot=${RLX}/cross-tools/${RLX_TGT} \
	--disable-nls \
	--enable-languages=c,c++ \
	--enable-c99 \
	--enable-long-long \
	--disable-libmudflap \
	--disable-multilib \
	--disable-libsanitizer


make
make install
