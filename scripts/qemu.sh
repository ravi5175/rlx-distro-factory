_id="qemu"
_desc="boot rlxos-$RLX_VER-$RLX_TGT.iso"

_qemu() {
	sudo xfce4-terminal -e "
	qemu-system-x86_64					\
		-kernel $RLX/boot/vmlinuz-rlx	\
		-initrd $RLX/boot/initrd		\
		-append 'console=ttyS0 root=/dev/sr0 squa=/rootfs.squa'	\
		-cdrom rlxos-$RLX_VER-$RLX_TGT.iso	\
		-enable-kvm						\
		-nographic						\
		-m 1024" --maximize
}
