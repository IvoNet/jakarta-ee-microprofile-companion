#!/usr/bin/env bash
version=$1
if [ -z ${version} ]; then
   read -p 'VM version: ' version
fi
./instance.sh
./resize-vm.sh
./export.sh "${version}"
