#!/bin/bash -e

apt-get install -y ffmpeg libsdl2-2.0-0 wget \
    gcc git pkg-config meson ninja-build libsdl2-dev \
    libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
    libswresample-dev libusb-1.0-0 libusb-1.0-0-dev \
    sudo unzip alsa-utils

# aptでadbをインストールするとapt pairコマンドがないため、直接adb最新版をインストール
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip  && \
    unzip platform-tools-latest-linux.zip -d /adb && \
    ln -s /adb/platform-tools/adb /usr/local/bin/adb

git clone https://github.com/Genymobile/scrcpy.git /scrcpy && \
    cd /scrcpy && \
    ./install_release.sh

git clone https://github.com/yx-saku/adb-wifi-debug.git /adb-wifi-debug

cat <<EOF > /usr/bin/mirroring.sh
#!/bin/bash

. /adb-wifi-debug/connect.sh
scrcpy --tcpip=\${CONNECTED_ADDRESS} \$SCRCPY_ARGS
EOF

chmod +x /usr/bin/mirroring.sh