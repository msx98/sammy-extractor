#!/bin/bash

echo "Downloading latest firmware"
REGION=$(cat config/region.txt)
MODEL=$(cat config/model.txt)
VERSION=$(samloader -m $MODEL -r $REGION checkupdate)
VERSION_SHORT=$(echo $VERSION | grep -o '....$')
TIME=$(date +%s)

echo $VERSION_SHORT > config/latest_firmware.txt

samloader -m $MODEL -r $REGION download -v $VERSION -O .
ENCRYPTED=$(ls *.enc4)
samloader -m $MODEL -r $REGION decrypt -v $VERSION -V 4 -i $ENCRYPTED -o $MODEL"-"$REGION"-"$VERSION_SHORT".zip"
#rm *.enc4

echo "Done"
