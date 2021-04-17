#!/usr/bin/env bash

if [ "$ENABLE_TC" == "true" ]
then
    tc qdisc add dev eth0 root handle 1: htb default 12
    tc class add dev eth0 parent 1:1 classid 1:12 htb rate ${BANDWIDTH}
    if [ "$LATENCY" -gt 0 ]; then
        if [ "$JITTER" -gt 0 ]; then
            tc qdisc add dev eth0 parent 1:12 netem delay ${LATENCY}ms ${JITTER}ms distribution normal
        else
            tc qdisc add dev eth0 parent 1:12 netem delay ${LATENCY}ms
        fi
    fi        
fi

service nginx start
uwsgi --ini uwsgi.ini