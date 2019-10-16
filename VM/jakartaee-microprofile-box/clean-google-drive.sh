#!/usr/bin/env bash
echo "Cleaning gooogle drive..."
for id in $(gdrive list --no-header|grep -e "jakartaee-microprofile-box.*zip"|awk '{print $1}'); do
    gdrive delete "${id}"
done
