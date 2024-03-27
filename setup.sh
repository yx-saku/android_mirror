#!/bin/bash -e

apt-get install -y wget git sudo unzip alsa-utils

git clone https://github.com/yx-saku/adb-wifi-debug.git /adb-wifi-debug
/adb-wifi-debug/setup.sh

apt-get install -y ffmpeg libsdl2-2.0-0 \
    gcc pkg-config meson ninja-build libsdl2-dev \
    libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
    libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

# scrcpy-serverのバージョンが合わないので修正してインストール
# https://github.com/Genymobile/scrcpy/issues/3421
git clone https://github.com/Genymobile/scrcpy
cd scrcpy
git checkout v2.4
sed -E 's#/v.*/scrcpy-server-v.*#/v2.4/scrcpy-server-v2.4#' -i ./install_release.sh
sed -E 's/^(.*sha256sum --check.*)$/#$1/' -i ./install_release.sh
./install_release.sh

cp -f ./bin/mirroring.sh /usr/bin/mirroring.sh