#!/bin/sh

# NOTE: Run as the build user!

set -e

mkdir -p "$REPO_DIR" "$APKTEMP_DIR"

# Get existing APKs in repo (if any)
apklist="$(find cache/repo/ -name "*.apk" | sed 's|.*/||')"
is_apk_indexed() {
	printf "%s" "$apklist" | tr ' ' '\n' | grep "^$1-" > /dev/null
	return $?
}

# drop-conf
if ! is_apk_indexed drop-conf; then
	# Make temporary APK with compressed sources in the cache directory
	mkdir -p "$APKTEMP_DIR/drop-conf/"
	cp "$APK_DIR/drop-conf/APKBUILD" "$APKTEMP_DIR/drop-conf/"
	cd "$APK_DIR/drop-conf"
	tar -czf "$APKTEMP_DIR/drop-conf/rootfs.tar.gz" rootfs
	cd "$APKTEMP_DIR/drop-conf"
	abuild checksum

	# build apk and index it in the repository
	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-conf', already indexed"
fi

# drop-firacode-nerd
if ! is_apk_indexed drop-firacode-nerd; then
	cp -r "$APK_DIR/drop-firacode-nerd/" "$APKTEMP_DIR/"
	cd "$APKTEMP_DIR/drop-firacode-nerd"
	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-firacode-nerd', already indexed"
fi

# drop-sent
if ! is_apk_indexed drop-sent; then
	mkdir -p "$APKTEMP_DIR/drop-sent/"
	cp "$APK_DIR/drop-sent/APKBUILD" "$APKTEMP_DIR/drop-sent/"
	cd "$APK_DIR/drop-sent"
	tar -czf "$APKTEMP_DIR/drop-sent/sent.tar.gz" sent
	cd "$APKTEMP_DIR/drop-sent"
	abuild checksum

	# build apk and index it in the repository
	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-sent', already indexed"
fi

# drop-helix
if ! is_apk_indexed drop-helix; then
	cp -r "$APK_DIR/drop-helix/" "$APKTEMP_DIR/"
	cd "$APKTEMP_DIR/drop-helix"
	abuild checksum

	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-helix', already indexed"
fi

# drop-st
if ! is_apk_indexed drop-st; then
	cp -r "$APK_DIR/drop-st/" "$APKTEMP_DIR/"
	cd "$APKTEMP_DIR/drop-st"
	abuild checksum

	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-st', already indexed"
fi

# drop-vt323
if ! is_apk_indexed drop-vt323; then
	cp -r "$APK_DIR/drop-vt323/" "$APKTEMP_DIR/"
	cd "$APKTEMP_DIR/drop-vt323"
	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-vt323', already indexed"
fi

# drop-wvkbd
_target_arch="$TARGET_ARCH"
unset TARGET_ARCH # Fix for linker failing to build
# TODO: Reconsider name for variable 'TARGET_ARCH'

if ! is_apk_indexed drop-wvkbd; then
	cp -r "$APK_DIR/drop-wvkbd/" "$APKTEMP_DIR/"
	cd "$APKTEMP_DIR/drop-wvkbd"
	abuild checksum

	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-wvkbd', already indexed"
fi
TARGET_ARCH="$_target_arch"

# drop-flat-remix-gtk
if ! is_apk_indexed drop-flat-remix-gtk; then
	cp -r "$APK_DIR/drop-flat-remix-gtk/" "$APKTEMP_DIR/"
	cd "$APKTEMP_DIR/drop-flat-remix-gtk"
	abuild -rf -P "$REPO_DIR"
else
	echo "[*] Skipped building APK 'drop-flat-remix-gtk', already indexed"
fi
