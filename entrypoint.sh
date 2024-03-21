#!/bin/bash

address="192.168.11.62"
port=$1
pair_port=$2
pair_code=$3

if [ "$port" == "" ]; then
    if [ -e ~/cache/port ]; then
        port=$(cat ~/cache/port)
    fi
fi

while true;
do
    connected_address=$(adb devices -l | grep SCG13 | awk '{ print $1 }')

    while [ "$connected_address" == "" ];
    do
        if [ "$port" == "" ]; then
            read -p "ポート：" port
        else
            echo "ポート：$port"
        fi

        adb connect ${address}:${port}

        connected_address=$(adb devices -l | grep SCG13 | awk '{ print $1 }')
        if [ "$connected_address" == "" ]; then
            if [ "$paired" == "true" ]; then
                port=
            else
                ret=
                while ! echo $ret | grep "Successfully paired";
                do
                    if [ "$pair_port" == "" ]; then
                        read -p "ペア設定ポート：" pair_port
                    else
                        echo "ペア設定ポート：$pair_port"
                    fi
                    if [ "$pair_code" == "" ]; then
                        read -p "ペア設定コード：" pair_code
                    else
                        echo "ペア設定コード：$pair_code"
                    fi

                    ret=$(adb pair ${address}:${pair_port} $pair_code)
                    echo $ret

                    pair_port=
                    pair_code=
                done

                paired=true
            fi
        fi
    done

    echo $port > ~/cache/port
    #scrcpy --tcpip=${connected_address} --max-size=480 --max-fps=1 --video-bit-rate=1M --audio-bit-rate=8K --audio-buffer=500 --window-height=720
    #scrcpy --tcpip=${connected_address} --max-size=480 --max-fps=1 --video-bit-rate=1M --audio-bit-rate=8K --audio-buffer=500 --audio-codec=aac --window-height=720
    scrcpy --list-encoders
    scrcpy --tcpip=${connected_address} --max-size=480 --max-fps=1 --video-bit-rate=1M --audio-bit-rate=8K --audio-buffer=500 --audio-codec=flac --window-height=720

    read -t 5 -p "yを入力で再起動：" input
    if [ "$input" == "y" ]; then
        echo "再起動"
    else
        echo "終了"
        break
    fi
done