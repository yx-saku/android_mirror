FROM ubuntu:latest

ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

RUN apt-get update && \
    apt-get install language-pack-ja fonts-takao zenity -y

COPY ./bin/mirroring.sh /android_mirror/bin/mirroring.sh
COPY ./setup.sh /android_mirror/setup.sh
RUN /android_mirror/setup.sh

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