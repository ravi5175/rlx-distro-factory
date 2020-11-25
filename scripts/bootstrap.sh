#!/bin/bash

_id="bootstrap"
_desc="bootstrap rlxos $RLX_VER"

_bootstrap() {

	for i in $(cat pkgs.list) ; do
		[[ -f rlx.$RLX_ARCH/var/lib/app/index/$i/info ]] && continue
		echo "building $i"
		[[ ! -f $(pwd)/$RLX_ARCH.appctl.specs ]] && {
			echo "specifications file missing"
			exit 1
		}
		check_ext $i && rm $RLX/rootfs
		APPCTL_SPECS=$(pwd)/$RLX_ARCH.appctl.specs	\
		appctl install $i							\
		config=$(pwd)/$RLX_ARCH.appctl.conf
		[[  $? != 0 ]] && {
			echo "failed to build $i"
			exit 1
		}
		
		check_ext $i && ln -sv . $RLX/rootfs

	done
}
