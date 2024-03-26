#!/bin/bash -e

. /adb-wifi-debug/connect.sh
scrcpy --tcpip=${CONNECTED_ADDRESS} $SCRCPY_ARGS