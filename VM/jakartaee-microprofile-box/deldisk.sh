#!/usr/bin/env bash

DISK=$1
if [ -z ${DISK} ]; then
   echo "Please specify a disk to remove.:"
   echo "e.g. deldisk.sh jakartaee-microprofile-box.vmdk"
   exit 1
fi

cd "${HOME}/VirtualBox VMs/jakartaee-microprofile-box"
deldisk() {
   if [[ -f $1 ]]; then
     rm -fv "$1"
   fi
   uuid=$(VBoxManage list hdds|tail -r|grep -A 4 $1|grep -A 2 inaccessible|grep ^UUID:|awk '{print $2}')
   if [ -z ${uuid} ]; then
      echo "Disk $1 does not seem to exist. Not deleted"
   else
      echo "Deleting: $1"
      vboxmanage closemedium disk ${uuid} --delete
   fi
}
deldisk $1
