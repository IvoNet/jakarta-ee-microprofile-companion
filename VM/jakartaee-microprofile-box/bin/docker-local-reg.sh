#!/bin/bash
PREFIX=localhost:32000
for image in $(docker image ls --format '{{.Repository}}:{{.Tag}}'); do
    if [[ $image == *"-project"* ]]; then
      docker tag ${image} ${PREFIX}/${image}
      docker push ${PREFIX}/${image}
      docker rmi ${image}
      docker rmi ${PREFIX}/${image}
    fi
done
