#!/usr/bin/env bash

VBoxManage
VBoxManage export jakartaee-microprofile-box -o "$(pwd)/../../usb-stick/VM/jakartaee-microprofile-box.ova"
