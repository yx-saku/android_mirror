#!/bin/bash

git config --global --add safe.directory /adb-wifi-debug

PWD=$(pwd)
cd /adb-wifi-debug
sudo git pull
cd "$PWD"

export PORT=$1
export PAIR_PORT=$2
export PAIR_CODE=$3

. /adb-wifi-debug/connect.sh
scrcpy --tcpip=${CONNECTED_ADDRESS} $SCRCPY_ARGS