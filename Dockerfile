FROM scrcpy-docker:latest

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

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

ENV PORT_CACHE_FILE=/home/$USER/cache/port

ENTRYPOINT [ "/entrypoint.sh" ]