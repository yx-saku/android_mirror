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

RUN apt-get install -y npm && \
    npm install n -g && \
    n stable && \
    apt-get purge -y nodejs npm && \
    apt-get autoremove -y

RUN npm i adb-wifi -g 

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

#ENV ADB_VENDOR_KEYS=/cache/adbkey

COPY entrypoint.sh ./entrypoint.sh
RUN sudo chmod +x ./entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]