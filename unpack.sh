#!/bin/bash

REGION=$(cat config/region.txt)
MODEL=$(cat config/model.txt)
FIRMWARE=$(cat config/firmware.txt)
if [ $1 -ne 0 ]
then
	FIRMWARE=$1
done

FILENAME=$MODEL"-"$REGION"-"$FIRMWARE".zip"

AP_FILE=$(unzip -l $FILENAME | egrep -o 'AP_.+')
BL_FILE=$(unzip -l $FILENAME | egrep -o 'BL_.+')
CP_FILE=$(unzip -l $FILENAME | egrep -o 'CP_.+')

FIRMWARE_TMP=$FIRMWARE"_tmp"

if [ -d $FIRMWARE ]
then
	echo "Firmware already extracted."
	echo "Aborting"
	exit
fi

mkdir -p $FIRMWARE_TMP
if [ ! -f $FIRMWARE_TMP"/"$BL_FILE ]; then unzip -jnq $(ls $FILENAME | tail -n 1) $BL_FILE -d $FIRMWARE_TMP | pv -l >/dev/null; fi # sboot.bin, param.bin, up_param.bin, cm.bin, keystorage.bin, uh.bin
if [ ! -f $FIRMWARE_TMP"/"$CP_FILE ]; then unzip -jnq $(ls $FILENAME | tail -n 1) $CP_FILE -d $FIRMWARE_TMP | pv -l >/dev/null; fi # modem.bin, modem_debug.bin
if [ ! -f $FIRMWARE_TMP"/"$AP_FILE ]; then unzip -jnq $(ls $FILENAME | tail -n 1) $AP_FILE -d $FIRMWARE_TMP | pv -l >/dev/null; fi # dt.img

pushd .
cd $FIRMWARE_TMP

for filename in sboot param up_param cm keystorage uh; do tar -xf $BL_FILE $filename".bin.lz4"; done;
for filename in modem modem_debug; do tar -xf $CP_FILE $filename".bin.lz4"; done
for filename in dt; do tar -xf $AP_FILE $filename".img.lz4"; done;

for filename in system vendor
do
	if [ ! -f $filename".img.lz4" ]; then tar -xf $AP_FILE $filename".img.lz4"; fi
	if [ ! -f $filename".img" ]; then unlz4 $filename".img.lz4"; fi
	if [ ! -f $filename"_raw.img" ]; then simg2img $filename".img" $filename"_raw.img"; fi
	mv $filename".img.lz4" $filename".img.lz4.bak"
	mv $filename".img" $filename".img.bak"
	mv $filename"_raw.img" $filename".img"
done

mkdir flash
for filename in $(ls *.lz4); do unlz4 $filename; rm -f $filename; mv $(echo "${filename/\.lz4/}") flash; done;
#rm -rf *.lz4 system.img vendor.img *.md5
mv system_raw.img system.img
mv vendor_raw.img vendor.img

popd
mv $FIRMWARE_TMP $FIRMWARE
