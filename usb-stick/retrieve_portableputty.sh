#!/usr/bin/env bash
mkdir windows 2>/dev/null

curl 'https://download3.portableapps.com/portableapps/PuTTYPortable/PuTTYPortable_0.71_English.paf.exe' \
      -H 'Upgrade-Insecure-Requests: 1' \
      -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36' \
      --compressed \
      -o ./windows/PuTTYPortable_0.71_English.paf.exe
