_profile() {
	profile_standard
	kernel_cmdline="unionfs_size=2G console=tty0 console=ttyS0,115200"
	syslinux_serial="0 115200"
	apks="$apks $(sh "$PROFILEDIR/apklist.sh")"
	apkovl="genapkovl-$PROFILENAME.sh"
}

eval "profile_$PROFILENAME() { _profile $@; }"
