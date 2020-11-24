#!/bin/bash

set -e

. config.sh
_ALGO=${ALGO:-"zstd"}
_EXCLUDE=${EXCLUDE:-"cross-tools rootfs"}
_AOUT=${AOUT:-"$(pwd)/rlxos-${RLX_VER}-${RLX_ARCH}"}

compress_tar() {
	cd $RLX
	_exstr=""
	for i in $_EXCLUDE ; do
		_exstr="$_exstr --exclude=$i"
	done
	
	echo "compressing $_AOUT.tar.${_ALGO}"
	tar ${_exstr} -caf "$_AOUT.tar.${_ALGO}" . 
	
	echo "tar is ready at $_AOUT.tar.${_ALGO}"
	cd -
}

compress_squa() {
	cd $RLX

	echo "compressing $_AOUT.squa"
	mksquashfs * "$_AOUT.squa" -wildcards -e "'$_EXCLUDE'" -comp $_ALGO
	
	echo "tar is ready at $_AOUT.squa"
	cd -
}

for i in $@ ; do
	
	case $i in
		tar|squa)
			_METHOD="compress_$i"
			;;
			
		--algo=*)
			_ALGO=${i*#=}
			;;
			
		--exclude=*)
			_EXCLUDE="$_EXCLUDE ${i*#=}"
			;;
		--output=*)
			_AOUT=${i*#=}
			;;
			
	esac
done

$_METHOD
