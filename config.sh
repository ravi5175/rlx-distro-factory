#!/bin/sh

set +h
umask 022
export RLX_VER="0.1.0"
export RLX_ARCH=${CARCH:-x86_64}
export RLX_HOST="$(echo ${MACHTYPE} | sed -e 's/-[^-]*/-cross/')"
export RLX=$(pwd)/rlx.$RLX_ARCH
export LC_ALL=POSIX
export PATH=${RLX}/cross-tools/bin:/bin
export RLX_SRC_DIR=$(pwd)/cache/src/
export RLX_BUILD_DIR=$(pwd)/cache/work/
export RLX_CACHE=$(pwd)/cache

export MAKEFLAGS=-j8

KERNEL_VERSION="5.8.13"
BINUTILS_VERSION="2.35"
GCC_VERSION="10.2.0"

MPFR_VERSION="4.1.0"
MPC_VERSION="1.1.0"
GMP_VERSION="6.2.0"
MUSL_VERSION="1.2.1"

case "$RLX_ARCH" in
	x86_64)
		export RLX_TGT="x86_64-linux-musl"
		;;
		
	i686)
		export RLX_TGT="i686-linux-musl"
		;;
		
	aarch64)
		export RLX_TGT="aarch64-linux-musl"
		;;
		
	armv7hl)
		export RLX_TGT="arm-linux-musleabihf"
		;;
		
	armv6hl)
		export RLX_TGT="arm-linux-musleabi"
		;;
		
	ppc64le)
		export RLX_TGT="powerpc64le-linux-musl"
		;;
		
	ppc64)
		export RLX_TGT="powerpc64-linux-musl"
		;;
		
	s390x)
		export RLX_TGT="s390x-linux-musl"
		;;
		
	riscv64)
		export RLX_TGT="riscv64-linux-musl"
		;;
	*)
		echo "unsupport architecture $RLX_ARCH"
		exit 1
esac

unset CFLAGS

INFO_MESG() {
    local WHITE_COLOR="\033[1;37m"
    local CYAN_COLOR="\033[1;36m"
    local NO_COLOR="\033[0m"

    echo -e "${WHITE_COLOR}[${CYAN_COLOR}Info${WHITE_COLOR}]:${NO_COLOR} $@"
}

ERR_MESG() {
    local WHITE_COLOR="\033[1;37m"
    local RED_COLOR="\033[1;31m"
    local NO_COLOR="\033[0m"
    echo -e "${WHITE_COLOR}[${RED_COLOR}Error${WHITE_COLOR}]:${RED_COLOR} $@${NO_COLOR}"
}

SUCCESS_MESG() {
    local WHITE_COLOR="\033[1;37m"
    local GREEN_COLOR="\033[1;32m"
    local NO_COLOR="\033[0m"
    echo -e "${WHITE_COLOR}[${GREEN_COLOR}Success${WHITE_COLOR}]:${GREEN_COLOR} $@${NO_COLOR}"
}

RLX_DOWNLOAD() {
    FILENAME=$(basename $1)
    [[ -z "$2" ]] || FILENAME="$2"
    URL=$1
    [[ -f $RLX_SRC_DIR/$FILENAME ]] || {
        [[ -f $RLX_SRC_DIR/$FILENAME.part ]] && RESUME="-c"
        INFO_MESG "Downloading $FILENAME from $URL"
        wget $RESUME --passive-ftp --tries=3 --waitretry=3 --output-document=$RLX_SRC_DIR/$FILENAME.part $URL &&    \
            mv $RLX_SRC_DIR/$FILENAME{.part,}
    }
}


RLX_EXTRACT() {
    [[ -d $RLX_BUILD_DIR ]] && rm -rf $RLX_BUILD_DIR

    mkdir -p $RLX_BUILD_DIR

    INFO_MESG "Extracting $1 -> $RLX_BUILD_DIR"
    tar -xf $RLX_SRC_DIR/$1 -C $RLX_BUILD_DIR/ || {
        ERR_MESG "Failed to extract $1"
        exit 1
    }
}


[[ -d ${RLX}/cross-tools/${RLX_TGT} ]] || {
	echo "preparing...."
	mkdir -p ${RLX}/cross-tools/${RLX_TGT}
	ln -sfv . ${RLX}/cross-tools/${RLX_TGT}/usr
	ln -sfv . ${RLX}/rootfs
	
	mkdir -p  ${RLX_CACHE}
	mkdir -p ${RLX_SRC_DIR}
	mkdir -p ${RLX_BUIL_DIR}
}

