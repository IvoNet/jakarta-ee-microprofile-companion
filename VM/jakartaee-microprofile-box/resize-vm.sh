#!/usr/bin/env bash
#https://organisemenet.wordpress.com/2017/01/05/bulk-delete-vbox-disk-medium/

VM_NAME=jakartaee-microprofile-box
VM_SIZE=15360

deldisk() {
   if [[ -f $1 ]]; then
     echo "Deleting file: $1"
     rm -fv "$1"
   fi
   uuid=$(VBoxManage list hdds|tail -r|grep -A 4 $1|grep -A 2 inaccessible|grep ^UUID:|awk '{print $2}')
   if [ -z ${uuid} ]; then
      echo "Disk $1 does not seem to exist in VirtualBox. Not deleted"
   else
      echo "Deleting from VirtualBox: $1"
      vboxmanage closemedium disk ${uuid} --delete
   fi
}

VBoxManage controlvm ${VM_NAME} poweroff 2>/dev/null
cd "${HOME}/VirtualBox VMs/${VM_NAME}"
VMDK=$(ls -1 *vmdk|grep -v configdrive)

echo "Cloning : ${VMDK}"
VBoxManage clonehd ${VMDK} "cloned.vdi" --format vdi

echo "Resizing: ${VMDK}"
VBoxManage modifyhd "cloned.vdi" --resize ${VM_SIZE}

vboxmanage storagectl ${VM_NAME} --name 'SCSI' --remove
deldisk ${VMDK}

VBoxManage clonehd cloned.vdi ${VM_NAME}.vmdk --format vmdk

deldisk cloned.vdi

echo "Adding SCSI driver"
vboxmanage storagectl ${VM_NAME} --name 'SCSI' --add scsi --controller LSILogic

echo "Adding hdd ${VM_NAME}.vmdk"
VBoxManage storageattach ${VM_NAME} \
                         --storagectl "SCSI" \
                         --device 0 \
                         --port 0 \
                         --type hdd \
                         --medium ${VM_NAME}.vmdk

echo "Adding the configdrive hdd"
VBoxManage storageattach ${VM_NAME} \
                         --storagectl "SCSI" \
                         --device 0 \
                         --port 1 \
                         --type hdd \
                         --medium ubuntu-bionic-18.04-cloudimg-configdrive.vmdk



cd -
vagrant up
