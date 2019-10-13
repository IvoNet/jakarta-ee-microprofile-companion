#!/usr/bin/env bash
version=$1
if [ -z ${version} ]; then
   read -p 'VM version: ' version
fi
vagrant destroy -f
vagrant box update
vagrant up
VBoxManage list vms
./export.sh "${version}"
