#!/usr/bin/env bash
#set -x
OVA=$(ls -1 *.ova|tail -r|head -1)
if [ -z ${OVA} ]; then
    echo "No *.ova file fond to import as an appliance..."
    exit 1
fi
echo "Importing: ${OVA}"
echo "Configuring host-only network with specific ip addresses..."
network_interface=$(VBoxManage hostonlyif create|grep Interface|awk '{print $2}'|sed "s/'//g")

VBoxManage hostonlyif ipconfig "${network_interface}" \
    --ip 192.168.10.1 \
    --netmask 255.255.255.0

VBoxManage dhcpserver add \
    --ifname "${network_interface}" \
    --ip 192.168.10.2 \
    --netmask 255.255.255.0  \
    --lowerip 192.168.10.100 \
    --upperip 192.168.10.200 \
    --enable
echo "The configured network to use is: ${network_interface}"

VM_NAME=jakartaee-microprofile-box
VBoxManage import "${OVA}" --vsys 0 --vmname ${VM_NAME} --options keepnatmacs
VBoxManage modifyvm ${VM_NAME} --nic2 hostonly --hostonlyadapter2 "${network_interface}"
VBoxManage startvm ${VM_NAME} --type headless
