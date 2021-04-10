#!/bin/bash

REGION=$(cat config/region.txt)
MODEL=$(cat config/model.txt)

FIRMWARE=$1
if [ ! -d $FIRMWARE ]
then
	echo "Can't find specified firmware.\nAborting"
	exit
fi

pushd .

cd $FIRMWARE"/flash"
for filename in sboot.bin param.bin up_param.bin cm.bin keystorage.bin uh.bin dt.img modem.bin modem_debug.bin
do
	if [ ! -f $filename ]
	then
		echo "Missing file: ${filename}"
		echo "Aborting"
		exit
	fi
done

heimdall flash \
	--BOOTLOADER sboot.bin \
	--PARAM param.bin \
	--UP_PARAM up_param.bin \
	--CM cm.bin \
	--KEYSTORAGE keystorage.bin \
	--UH uh.bin \
	--DTB dt.img \
	--RADIO modem.bin \
	--CP_DEBUG modem_debug.bin

popd
