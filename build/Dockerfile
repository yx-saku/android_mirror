FROM ubuntu:latest

RUN apt-get update

RUN apt-get install -y ffmpeg libsdl2-2.0-0 wget \
    gcc git pkg-config meson ninja-build libsdl2-dev \
    libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
    libswresample-dev libusb-1.0-0 libusb-1.0-0-dev \
    sudo unzip alsa-utils

# aptでadbをインストールするとapt pairコマンドがないため、直接adb最新版をインストール
RUN wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip  && \
    unzip platform-tools-latest-linux.zip && \
    ln -s $(pwd)/platform-tools/adb /usr/local/bin/adb

RUN git clone https://github.com/Genymobile/scrcpy.git && \
    cd scrcpy && \
    ./install_release.sh

RUN git clone https://github.com/yx-saku/adb-wifi-debug.git /adb-wifi-debug 