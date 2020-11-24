#!/bin/bash

set -e

. config.sh
_ALGO=${ALGO:-"zstd"}
_EXCLUDE=${EXCLUDE:-"cross-tools"}
_AOUT=${AOUT:-"rlxos-${RLX_VER}-${RLX_ARCH}"}

compress_tar() {
	cd $RLX
	_exstr=""
	for i in $_EXCLUDE ; do
		_exstr="$exstr --exclude='$i'"
	done
	
	echo "compressing $_AOUT.tar.${_ALGO}"
	tar -caf "$_AOUT.tar.${_ALGO}" "${_exstr}" *
	
	echo "tar is ready at $_AOUT.tar.${_ALGO}"
	cd -
}

compress_squa() {
	cd $RLX

	echo "compressing $_AOUT.squa"
	mksquashfs * "$_AOUT.squa" -wildcards -e "'$_EXCLUDE'"
	
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
