#!/usr/bin/env bash
###############################################################################
# Config section.
###############################################################################
# https://download.virtualbox.org/virtualbox/6.0.14/VirtualBox-6.0.14-133895-OSX.dmg
# https://www.virtualbox.org/wiki/Downloads
VIRTUALBOX_VERSION=6.0.14
VIRTUALBOX_MINOR_VERSION=133895

###############################################################################
# Please do not edit below this line unless you really know what you are doing
###############################################################################
mkdir linux 2>/dev/null
mkdir osx 2>/dev/null
mkdir windows 2>/dev/null
VIRTUALBOX_EXT_WIN="-Win.exe"
VIRTUALBOX_EXT_OSX="-OSX.dmg"
VIRTUALBOX_EXT_SUN="-SunOS.tar.gz"
VIRTUALBOX_EXT_1804="~Ubuntu~bionic_amd64.deb"
VIRTUALBOX_BASE_NAME="VirtualBox-${VIRTUALBOX_VERSION}-${VIRTUALBOX_MINOR_VERSION}"
VIRTUALBOX_BASE_URL="https://download.virtualbox.org/virtualbox/${VIRTUALBOX_VERSION}/"

download() {
    echo "Downloading: $1"
    curl -sL "$2" \
         -H 'Connection: keep-alive' \
         -H 'Upgrade-Insecure-Requests: 1' \
         -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36' \
         -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' \
         -H 'Accept-Encoding: gzip, deflate, br' \
         -H 'Accept-Language: en-US,en;q=0.9,nl;q=0.8' \
         --compressed \
         -o "$1"
}

download_virtualbox() {
    download "./VM/${VIRTUALBOX_BASE_NAME}$1" "${VIRTUALBOX_BASE_URL}${VIRTUALBOX_BASE_NAME}$1"
}

download_virtualbox ${VIRTUALBOX_EXT_WIN}
download_virtualbox ${VIRTUALBOX_EXT_OSX}
#download_virtualbox ${VIRTUALBOX_EXT_SUN}
download "./VM/virtualbox-6.0_${VIRTUALBOX_VERSION}-${VIRTUALBOX_MINOR_VERSION}${VIRTUALBOX_EXT_1804}" "${VIRTUALBOX_BASE_URL}/virtualbox-6.0_${VIRTUALBOX_VERSION}-${VIRTUALBOX_MINOR_VERSION}${VIRTUALBOX_EXT_1804}"
download "./VM/Oracle_VM_VirtualBox_Extension_Pack-${VIRTUALBOX_VERSION}.vbox-extpack" "${VIRTUALBOX_BASE_URL}/Oracle_VM_VirtualBox_Extension_Pack-${VIRTUALBOX_VERSION}.vbox-extpack"
