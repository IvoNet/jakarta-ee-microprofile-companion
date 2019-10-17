#!/usr/bin/env bash

vagrant destroy -f
rm -rf "${HOME}/VirtualBox VMs/jakartaee-microprofile-box" 2>/dev/null
vagrant box update
vagrant up
