#!/bin/sh

set -e

mkdir -p "$INITRD_DIR"
cd "$INITRD_DIR"

# Create init script
# TODO: Look for better way of finding CDROM device
cat <<- EOF > init
#!/bin/sh

dmesg -n 1

echo "Mounting pseudo filesystems..."
mkdir -p /dev /proc /sys
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys

if [ ! -z "\$droproot" ]; then
	# installed
	echo "Mounting rootfs at /new_root..."
	for i in \$(seq 1 5); do
		rootdev="\$(findfs "\$droproot" | head -n 1)"
		if [ -z "\$rootdev" ] || [ ! -b "\$rootdev" ]; then
			echo "Failed to find root device, trying again..."
			sleep 1
		else
			break
		fi
	done

	if [ -z "\$rootdev" ] || [ ! -b "\$rootdev" ]; then
		echo "Failed to find root device, spawning troubleshoot shell..."
		exec /bin/sh
	fi

	mkdir -p /new_root

	if blkid "\$rootdev" | grep 'TYPE="crypto_LUKS"' > /dev/null; then
		mkdir -p /run
		cryptsetup luksOpen "\$rootdev" cryptdrop
		if [ ! -b /dev/mapper/cryptdrop ]; then
			echo "Failed to decrypt root device, spawning troubleshoot shell..."
			exec /bin/sh
		fi

		mount /dev/mapper/cryptdrop /new_root
	else
		mount "\$rootdev" /new_root
	fi
else
	# liveboot
	echo "Mounting cdrom at /cdrom..."
	for i in \$(seq 1 5); do
		cdromdev="\$(findfs "LABEL=$ISO_VOLID" | head -n 1)"
		if [ -z "\$cdromdev" ] || [ ! -b "\$cdromdev" ]; then
			echo "Failed to find CDROM device, trying again..."
			sleep 1
		else
			break
		fi
	done

	if [ -z "\$cdromdev" ] || [ ! -b "\$cdromdev" ]; then
		echo "Failed to find CDROM device, spawning troubleshoot shell..."
		exec /bin/sh
	fi

	mkdir -p /cdrom
	mount "\$cdromdev" /cdrom

	echo "Mounting squashfs at /live..."
	mkdir -p /live
	mount /cdrom/rootfs.squashfs /live

	echo "Mounting overlayfs at /new_root..."
	mkdir -p /upper /work /new_root
	mount -t overlay overlay -o lowerdir=/live,upperdir=/upper,workdir=/work /new_root

	echo "Mounting readonly CDROM at /new_root/cdrom..."
	mkdir -p /new_root/cdrom
	mount -r "\$cdromdev" /new_root/cdrom

	echo "Mounting squashfs at /new_root/squash..."
	mkdir -p /new_root/squash
	mount -r /new_root/cdrom/rootfs.squashfs /new_root/squash
fi

echo "Mounting pseudo filesystems for new root.."
mkdir -p /new_root/dev /new_root/proc /new_root/sys
mount -t devtmpfs none /new_root/dev
mount -t proc none /new_root/proc
mount -t sysfs none /new_root/sys

# echo "Spawning shell (exit to continue init)..."
# /bin/sh

exec switch_root /new_root /sbin/init
EOF
chmod +x init

# Install busybox
mkdir -p bin usr/bin sbin usr/sbin
cp "$BUSYBOX_DIR/busybox" "$INITRD_DIR/bin/busybox"
chroot . /bin/busybox --install

# Install cryptsetup
if [ ! -d "$INITRD_DIR/etc/apk" ]; then
	apk add --initdb -p "$INITRD_DIR"
fi

apk add \
	-p "$INITRD_DIR" \
	--allow-untrusted \
	--no-cache \
	--repositories-file="$REPOS_FILE" \
	cryptsetup

# Compress files into initramfs
find . | cpio -R root:root -H newc -o | gzip > "$INITRAMFS_PATH"

cd "$ROOT_DIR"
