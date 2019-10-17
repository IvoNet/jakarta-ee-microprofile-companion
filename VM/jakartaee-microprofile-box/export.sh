#!/usr/bin/env bash

CLEAN_UP=1
VM_NAME=jakartaee-microprofile-box

version=$1
if [ -z ${version} ]; then
   read -p 'VM version: ' version
fi

VBoxManage controlvm ${VM_NAME} poweroff 2>/dev/null

if [[ ${CLEAN_UP} -eq 1 ]]; then
    rm -fv ../../usb-stick/VM/${VM_NAME}_v*.ova
    rm -fv ../../usb-stick/${VM_NAME}_v*.zip
    ./clean-google-drive.sh
fi

cd "$(pwd)/../../usb-stick/"

echo "Exporting..."
VBoxManage export ${VM_NAME} -o "VM/${VM_NAME}_v${version}.ova"


echo "Compressing..."
zip -r -0 ${VM_NAME}_v${version}.zip VM

echo "Uploading compressed image to google drive..."
url=$(gdrive upload --share "${VM_NAME}_v${version}.zip"|grep "anyone"|awk '{print $7}')
cd -

if [ -z ${url} ]; then
    echo "Something went wrong..."
    exit 1
fi

echo -n ${url}|pbcopy
echo "Download URL copied to clipboard..: "
echo "${url}"

#echo "Change the tiny url id 471 please"
#open https://ivo2u.nl/h2console

echo "You might want to update the text in this document..."
open http://ivo2u.nl/oI
