#!/usr/bin/env bash

CLEAN_UP=1
VM_NAME=jakartaee-microprofile-box

version=$1
if [ -z ${version} ]; then
   read -p 'VM version: ' version
fi

VBoxManage controlvm ${VM_NAME} poweroff 2>/dev/null

#Always cleanup the last ova as it will otherwise be zipped
rm -fv ../../usb-stick/VM/${VM_NAME}_v*.ova
if [[ ${CLEAN_UP} -eq 1 ]]; then
    rm -fv ../../usb-stick/${VM_NAME}_v*.zip
    ./clean-google-drive.sh
fi

cd "$(pwd)/../../usb-stick/"

echo "Exporting..."
VBoxManage export ${VM_NAME} -o "VM/${VM_NAME}_v${version}.ova"


echo "Compressing..."
zip -r -0 ${VM_NAME}_v${version}.zip VM

cd ../../usb-stick

echo "Uploading compressed image to google drive..."
${drive} push -no-prompt "${VM_NAME}_v${version}.zip"
${drive} pub -quiet "${VM_NAME}_v${version}.zip"
url=$(drive ls -long |grep "${VM_NAME}_v${version}.zip"|awk '{print "https://drive.google.com/uc?export=download&id="$4}')

cd -

if [ -z ${url} ]; then
    echo "Something went wrong..."
    exit 1
fi

echo -n ${url}|pbcopy
echo "Download URL copied to clipboard..: "
echo "${url}"
echo $(/Users/iwo16283/dev/ivonet-macbook-install/bin/ivo2u "${url}")


echo "You might want to update the text in this document..."
open http://ivo2u.nl/oI

echo "Change the tiny url id 477 please"
open https://ivo2u.nl/h2console
