FROM ubuntu:latest

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

RUN apt-get update && \
    apt-get install language-pack-ja fonts-takao zenity -y

# TODO 問題なさそうならsetupにする
#COPY setup.sh ./setup.sh
#RUN ./setup.sh

RUN apt-get install -y wget git sudo unzip alsa-utils

RUN git clone https://github.com/yx-saku/adb-wifi-debug.git /adb-wifi-debug && \
    /adb-wifi-debug/setup.sh

RUN apt-get install -y ffmpeg libsdl2-2.0-0 \
    gcc pkg-config meson ninja-build libsdl2-dev \
    libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev \
    libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

# scrcpy-serverのバージョンが合わないので修正してインストール
# https://github.com/Genymobile/scrcpy/issues/3421
RUN git clone https://github.com/Genymobile/scrcpy && \
    cd scrcpy && \
    git checkout v2.4 && \
    sed -E 's#/v.*/scrcpy-server-v.*#/v2.4/scrcpy-server-v2.4#' -i ./install_release.sh && \
    sed -E 's/^(.*sha256sum --check.*)$/#$1/' -i ./install_release.sh && \
    ./install_release.sh

COPY ./bin/mirroring.sh /usr/bin/mirroring.sh

COPY entrypoint.sh /entrypoint.sh

# 作業ユーザー作成
ARG UID=1000
ARG GID=1000
ARG USER
ARG GROUP
RUN <<EOF
    groupadd -g $GID $GROUP
    useradd -u $UID -g $GROUP -m -s /bin/bash $USER
    echo "${USER}:${USER}" | chpasswd
    adduser $USER sudo
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
EOF

USER $USER

ENTRYPOINT [ "/entrypoint.sh" ]