#!/usr/bin/env bash
echo "Cleaning gooogle drive..."
for id in $(gdrive list --no-header|grep -e "jakartaee-microprofile-vm_v.*zip"|awk '{print $1}'); do
    gdrive delete "${id}"
done
