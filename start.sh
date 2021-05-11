#!/usr/bin/env bash

if [ "$ENABLE_TC" == "true" ]
then
    if [ "$ENABLE_PREFETCHING" == "true" ]
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
    else
        for h in $(seq 1 $N_CLIENTS)
        do
            CIP=$(getent hosts ${CLIENT_HOST}_${h} | cut -d' ' -f1)
            echo "./traffic-control.sh -o --delay=${LATENCY} --jitter=${JITTER} --uspeed=${BANDWIDTH} --dspeed=${BANDWIDTH} ${CIP}"
            tc qdisc add dev eth0 root handle 1a1a: htb default 1
            tc class add dev eth0 parent 1a1a: classid 1a1a:${h} htb rate ${BANDWIDTH}
            tc qdisc add dev eth0 parent 1a1a:${h} handle 220${h}: netem delay ${LATENCY}ms
            tc filter add dev eth0 protocol ip parent 1a1a: prio 1 u32 match ip dst ${CIP} flowid 1a1a:${h}
        done
    fi
        
fi

service nginx start
uwsgi --ini uwsgi.ini