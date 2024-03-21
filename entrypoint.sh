#!/bin/bash

export PORT=$1
export PAIR_PORT=$2
export PAIR_CODE=$3

. /adb-wifi-debug/connect.sh
scrcpy --tcpip=${CONNECTED_ADDRESS} $SCRCPY_ARGS