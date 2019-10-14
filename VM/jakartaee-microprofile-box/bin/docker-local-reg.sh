#!/bin/bash
for image in $(docker image ls --format '{{.Repository}}:{{.Tag}}'); do
    if [[ $image == *"-project"* ]]; then
      docker tag ${image} 192.168.10.100:32000/${image}
      docker push 192.168.10.100:32000/${image}
      docker rmi ${image}
      docker rmi 192.168.10.100:32000/${image}
    fi
done
