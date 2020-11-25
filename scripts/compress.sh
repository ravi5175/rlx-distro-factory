#!/bin/bash

_id="compress"
_desc="compress bootstrap build"


_ALGO=${ALGO:-"zstd"}
_EXCLUDE=${EXCLUDE:-"cross-tools"}
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

compress_cpio() {
	cd $RLX

	_exstr=""
	for i in $_EXCLUDE ; do
		_exstr="$_exstr -type d -name $i -prune"
	done
	
	echo "compressing initrd ($_exstr)"
	find . $_exstr -o -print | cpio -o -H newc --quiet | gzip -9 > $_AOUT.cpio.gz
	
	echo "initrd is ready $_AOUT.cpio.gz"
	cd -
}

compress_squa() {
	cd $RLX

	_exstr=""
	for _i in $_EXCLUDE ; do
		_exstr="$_exstr -e $_i/*"
	done
	echo "compressing $_AOUT.squa"
	mksquashfs $RLX "$_AOUT.squa" \
		-comp $_ALGO			  \
		$_exstr
		 
	
	echo "tar is ready at $_AOUT.squa"
	cd -
}

_compress() {
	for i in $@ ; do
		
		case $i in
			tar|squa|cpio)
				_METHOD="compress_$i"
				;;
				
			--algo=*)
				_ALGO=${i#*=}
				;;
				
			--exclude=*)
				_EXCLUDE="$_EXCLUDE ${i#*=}"
				;;
			--output=*)
				_AOUT=${i#*=}
				;;
				
		esac
	done
$_METHOD
}

