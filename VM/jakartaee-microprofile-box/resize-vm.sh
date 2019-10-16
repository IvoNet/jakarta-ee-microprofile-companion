#!/usr/bin/env bash

VM_NAME=jakartaee-microprofile-box
VM_SIZE=15360
VBoxManage controlvm ${VM_NAME} poweroff 2>/dev/null
cd "~/VirtualBox VMs/${VM_NAME}"
VBoxManage clonehd "ubuntu-bionic-18.0.4-cloudimg.vmdk" "cloned.vdi" --format vdi
VBoxManage modifyhd "cloned.vdi" --resize ${VM_SIZE}
VBoxManage clonehd cloned.vdi ${VM_NAME}.vmdk --format vmdk

vboxmanage storagectl ${VM_NAME} --name 'SCSI' --remove
vboxmanage storagectl ${VM_NAME} --name 'SCSI' --add scsi --controller LSILogic

VBoxManage storageattach ${VM_NAME} \
                         --storagectl "SCSI" \
                         --device 0 \
                         --port 0 \
                         --type hdd \
                         --medium ${VM_NAME}.vmdk

VBoxManage storageattach ${VM_NAME} \
                         --storagectl "SCSI" \
                         --device 0 \
                         --port 1 \
                         --type hdd \
                         --medium ubuntu-bionic-18.04-cloudimg-configdrive.vmdk

rm -f cloned.vdi
cd -
vagrant up
