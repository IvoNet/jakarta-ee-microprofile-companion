#!/usr/bin/env bash

version=$1
if [ -z ${version} ]; then
   echo "Just provide the version part (e.g. 0.3 or 1.0) from the file you downloaded"
   read -p 'VM version: ' version
fi

echo "Configuring host-only network with specific ip addresses..."
network_interface=$(VBoxManage hostonlyif create|grep Interface|awk '{print $2}'|sed "s/'//g")
VBoxManage hostonlyif ipconfig "${network_interface}" --ip 192.168.10.1 --netmask 255.255.255.0
VBoxManage dhcpserver add --ifname "${network_interface}" --ip 192.168.10.2 --netmask 255.255.255.0 --lowerip 192.168.10.100 --upperip 192.168.10.200 --enable
echo "The configured network to use is: ${network_interface}"


VBoxManage import "jakartaee-microprofile-box_v${version}.ova" --options keepnatmacs
VBoxManage startvm jakartaee-microprofile-box --type headless
