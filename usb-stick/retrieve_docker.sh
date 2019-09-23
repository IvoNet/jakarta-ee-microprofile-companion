#!/usr/bin/env bash
mkdir linux 2>/dev/null
mkdir osx 2>/dev/null
mkdir windows 2>/dev/null

docker_download() {
    echo "Downloading: $2"
    curl "https://download.docker.com/$1"                                                                                             \
        -H 'authority: download.docker.com'                                                                                                        \
        -H 'upgrade-insecure-requests: 1'                                                                                                          \
        -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.100 Safari/537.36' \
        -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3'        \
        -H 'accept-encoding: gzip, deflate, br'                                                                                                    \
        -H 'accept-language: en-US,en;q=0.9,nl;q=0.8'                                                                                              \
        --compressed -s                                                                                                                              \
        -o "$2"
}

docker_download "mac/edge/Docker.dmg" "./osx/Docker-edge.dmg"
docker_download "mac/stable/Docker.dmg" "./osx/Docker.dmg"
docker_download "win/stable/Docker%20for%20Windows%20Installer.exe" "./windows/Docker for Windows Installer.exe"

