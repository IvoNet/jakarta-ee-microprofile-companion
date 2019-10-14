#!/usr/bin/env bash
docker rm -f ui 2>/dev/null
docker run -d --name ui -p 8888:80 -e REGISTRY_TITLE="Docker Registry" -e REGISTRY_URL="http://192.168.10.100:32000" joxit/docker-registry-ui:static
