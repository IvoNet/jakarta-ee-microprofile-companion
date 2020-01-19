#!/usr/bin/env bash
drive=/Users/iwo16283/go/bin/drive
echo "Cleaning gooogle drive..."
for id in $(${drive} ls|grep -e "docker-box.*zip"); do
    ${drive} delete "$(echo ${id} | cut -c2-)"
done
