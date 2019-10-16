#!/usr/bin/env bash
version=$1
if [ -z ${version} ]; then
   read -p 'VM version: ' version
fi
vagrant destroy -f
vagrant box update
vagrant up
./resize-vm.sh
VBoxManage list vms
./export.sh "${version}"
