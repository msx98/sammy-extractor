#!/bin/bash

USERNAME=$(cat config/linux_username.txt)
REGION=$(cat config/region.txt)
DIR_REPO=$(cat config/repo.txt)
DIR_PROP=$DIR_REPO$(cat config/path_folder_proprietary.txt)
EXTRACT_SCRIPT=$DIR_REPO$(cat config/path_extract_script.txt)
FIRMWARE=$(cat config/firmware.txt)
FIRMWARE_DIR=$REGION"-"$FIRMWARE

if [ $(whoami) != "root" ]
then
	echo "Must run as root!"
	echo "Aborting"
	exit
fi

cd $FIRMWARE_DIR
mkdir rootfs
mount system.img rootfs
mount vendor.img rootfs/vendor

$EXTRACT_SCRIPT $(pwd)/rootfs
chown -R $USERNAME:$USERNAME $DIR_PROP
umount rootfs/vendor
umount rootfs
rm -rf rootfs
cp -R $DIR_PROP .
chown -R $USERNAME:$USERNAME proprietary
cd ..
