#!/usr/bin/env bash

for image in $(docker images --format '{{.Repository}}:{{.Tag}}'); do
   tag="localhost:32000/$(echo -n ${image}|sed 's#/#-#g')"
   docker tag ${image} ${tag}
   docker push ${tag}
   docker rmi ${tag}
done
