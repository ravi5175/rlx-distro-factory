#!/bin/bash

_id="iso"
_desc="generate iso for bootstrap"

_iso() {
	buildno=$(cat buildno)
	((buildno=buildno+1))
	echo $buildno > buildno
	mkdir -p cache/iso.$buildno/boot/grub

	echo "
	timeout=5
	default=0

	menuentry 'rlxos $buildno' {
		linux /boot/vmlinuz-rlx root=/dev/sr0 squa=/rootfs.squa
		initrd /boot/initrd
	}
	" > cache/iso.$buildno/boot/grub/grub.cfg

	mksquashfs $RLX $(pwd)/cache/iso.$buildno/rootfs \
		-e $RLX/cross-tools/* \
		-e $RLX/rootfs/* 
	sudo chroot $RLX rlx-init -k=$KERNEL_VERSION-rlxos -iso

	sudo cp $RLX/boot/{vmlinuz-rlx,initrd} cache/iso.$buildno/boot/

	sudo chown $USER $RLX/boot/* -Rv 
	chmod 755 $RLX/boot/initrd -v

	sudo grub-mkrescue -o rlxos-$RLX_VER-$RLX_TGT.iso cache/iso.$buildno/ -volid RLX
}



