#!/bin/bash

SHELL_PATH=$(cd $(dirname $0); pwd)

sed -E 's#Path=/path/to/project/root#Path=/home/selsxprob/android_mirror#' ${SHELL_PATH}/mirroring.desktop-template > ${SHELL_PATH}/mirroring.desktop

sudo ln -fs ${SHELL_PATH}/mirroring.desktop /usr/share/applications/mirroring.desktop