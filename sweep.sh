#!/bin/bash

REMOTE_HOST=your.host.ip.addr
PREFIX=`date "+%Y%m%d-%H%M%S"`

function remoteCommandSync {
    ssh $REMOTE_HOST "$@"
}

function remoteCommandBackground {
    ssh $REMOTE_HOST "$@" &> /dev/null < /dev/null &
}

for target in {100..3000..100}; do
    LOGDIR="results/${PREFIX}-target${target}"

    mkdir -p "${LOGDIR}"

    remoteCommandSync mkdir -p "${LOGDIR}"
    remoteCommandBackground sar -A 5 \&\> "${LOGDIR}/sut.sar.out"

    sar -A 5 &> "${LOGDIR}/driver.sar.out" &
    
    node ccperf.js run \
	 --profile connection-profile.yaml \
	 --processes 16 \
	 --target $target \
	 --org org1 \
	 --duration 120 \
	 --num 4 \
	 --size 64 \
	 --endorsing-peer peer1.org1.example.com \
	 --committing-peer peer1.org1.example.com \
	 --type putstate \
	 --logdir "${LOGDIR}" 2>&1 | tee "${LOGDIR}/ccperf.log"

    remoteCommandSync killall sar
    killall sar
    
    sleep 60
done
