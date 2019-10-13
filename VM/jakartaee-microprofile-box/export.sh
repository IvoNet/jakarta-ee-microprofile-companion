#!/usr/bin/env bash

version=$1
if [ -z ${version} ]; then
   read -p 'VM version: ' version
fi

VBoxManage controlvm jakartaee-microprofile-box poweroff 2>/dev/null
echo "Exporting..."
VBoxManage export jakartaee-microprofile-box -o "$(pwd)/../../usb-stick/VM/jakartaee-microprofile-box_v${version}.ova"

cd "$(pwd)/../../usb-stick/"

echo "Compressing..."
zip -r -0 jakartaee-microprofile-box_v${version}.zip VM

echo "Uploading compressed image to google drive..."
url=$(gdrive upload --share "jakartaee-microprofile-box_v${version}.zip"|grep "anyone"|awk '{print $7}')
rm -f "VM/jakartaee-microprofile-box_v${version}.ova"
rm -f "jakartaee-microprofile-box_v${version}.zip"
cd -

echo ${url}|pbcopy
echo "Download URL copied to clipboard..: "
echo "${url}"

echo "Change the tiny url id 471 please"
open https://ivo2u.nl/h2console
