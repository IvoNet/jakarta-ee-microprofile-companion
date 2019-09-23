#!/usr/bin/env bash
mkdir linux 2>/dev/null
mkdir osx 2>/dev/null
mkdir windows 2>/dev/null

pull_or_clone() {
    if [ -d "$1" ]; then
        echo "Updating exiting repo"
        cd "$1"
        git pull
        git branch -r | grep -v grep | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote" ;done
        cd -
    else
        echo "Cloning repo"
        git clone https://github.com/IvoNet/docker-from-scratch.git "$1"
        cd "$1"
        git branch -r | grep -v grep | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote" ;done
        cd -
    fi
}

pull_or_clone ./linux/docker-from-scratch
pull_or_clone ./windows/docker-from-scratch
pull_or_clone ./osx/docker-from-scratch

#git clone https://github.com/IvoNet/docker-from-scratch.git ./linux/docker-from-scratch
#git clone https://github.com/IvoNet/docker-from-scratch.git ./windows/docker-from-scratch
#git clone https://github.com/IvoNet/docker-from-scratch.git ./osx/docker-from-scratch

