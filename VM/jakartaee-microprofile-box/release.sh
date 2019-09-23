#!/usr/bin/env bash
vagrant destroy -f
vagrant box update
vagrant up
VBoxManage list vms
VBoxManage controlvm jakartaee-microprofile-box poweroff
VBoxManage export jakartaee-microprofile-box -o "$(pwd)/../../usb-stick/VM/jakartaee-microprofile-box.ova"
vagrant up
