#!/bin/bash

. config.sh

echo "
       .__                      
_______|  | ___  ___   ____  ______
\_  __ \  | \  \/  /  /  _ \/  ___/
 |  | \/  |__>    <  (  <_> )___ \ 
 |__|  |____/__/\_ \  \____/____  >
                  \/            \/ 
  welcome to rlxos distro factory
-----------------------------------------

Target System: $RLX_TGT
Architecture : $RLX_ARCH
Build dir    : $RLX
"

_x=0
echo -en "verifying toolchain\t\t"
for i in toolchain/*.sh ; do
	_ttfile=${RLX_CACHE}/$(basename $i)
	[[ -f $_ttfile ]] && continue
	[[ $_x = 0 ]] && {
		_x=1
		echo -e "   [missing]\nCompiling toolchain"
	}
	echo "compiling $(basename $i)"
	(. $i) || {
		echo ": error : failed to compile $i"
		exit 1
	}
	
	touch $_ttfile
done
unset _x
echo "   [✓]"

echo -en "generating appctl configs\t"
echo "
set +h
umask 022
export RLX=$(pwd)/rlx.$RLX_ARCH
export LC_ALL=$LC_ALL
export PATH=$PATH
export RLX_ARCH=$RLX_ARCH
export RLX_HOST=$RLX_HOST
export MAKEFLAGS=-j8
export RLX_TARGET=$RLX_TGT
export CFLAGS=\"-O2 -march=x86-64 -pipe\"
export CXXFLAGS=\$CFLAGS

export BOOTSTRAP=1

export CC=\"$RLX_TGT-gcc --sysroot=$RLX/rootfs\"
export CXX=\"$RLX_TGT-g++ --sysroot=$RLX/rootfs\"
export LD=\"$RLX_TGT-ld --sysroot=$RLX/rootfs\"
export AR=\"$RLX_TGT-ar\"
export AS=\"$RLX_TGT-as\"
export RANLIB=\"$RLX_TGT-ranlib\"
export STRIP=\"$RLX_TGT-strip\"

export TARGET=$RLX_TGT
export HOST=$RLX_HOST
" > $(pwd)/$RLX_ARCH.appctl.specs

echo "
[dir]
recipes = $(pwd)/recipes
cache = $(pwd)/cache
pkg = $(pwd)/pkgs.$RLX_ARCH
data = $(pwd)/rlx.$RLX_ARCH/var/lib/app/index
roots = $(pwd)/rlx.$RLX_ARCH

[modules]
rlxpkg = /usr/libexec/appctl/rlxpkg

[default]
repo = core toolchain
" > $(pwd)/$RLX_ARCH.appctl.conf

echo "   [✓]"

for i in $(cat pkgs.list) ; do
	[[ -f rlx.$RLX_ARCH/var/lib/app/index/$i/info ]] && continue
	echo "building $i"
	[[ ! -f $(pwd)/$RLX_ARCH.appctl.specs ]] && {
		echo "specifications file missing"
		exit 1
	}
	APPCTL_SPECS=$(pwd)/$RLX_ARCH.appctl.specs	\
	appctl install $i							\
	config=$(pwd)/$RLX_ARCH.appctl.conf
	[[  $? != 0 ]] && {
		echo "failed to build $i"
		exit 1
	}

done
