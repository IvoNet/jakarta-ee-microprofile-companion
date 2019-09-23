#!/usr/bin/env bash
mkdir windows 2>/dev/null
echo "Downloading: Shortcut.exe"
curl 'http://www.optimumx.com/download/Shortcut.zip' \
      -H 'Upgrade-Insecure-Requests: 1' \
      -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36' \
      --compressed -s\
      -o ./windows/Shortcut.zip

cd windows
unzip -o Shortcut.zip
rm -f Shortcut.zip
rm -f ReadMe.txt
cd -
