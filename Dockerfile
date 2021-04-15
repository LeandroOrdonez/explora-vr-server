FROM python:3.7-slim

ENV FLASK_APP="run.py"
ENV APP_SETTINGS="production"
ENV QUERY_LOG="./issued_queries.log"
ENV ENABLE_TC="false"
ENV BANDWIDTH="25Mbps"
ENV LATENCY="15ms"
ENV JITTER="1.5ms"

ARG gid=www-data
ARG uid=www-data

WORKDIR /app

ADD . /app

RUN chown -R ${uid}:${gid} /app

RUN apt-get clean \
    && apt-get update 
    
RUN apt-get install -y nginx gcc g++ openssh-server libspatialindex-dev libpq-dev htop build-essential python-dev python3-dev iproute2 inetutils-ping iperf3 bmon
RUN pip install -r requirements.txt --src /usr/local/src

# RUN tc qdisc add dev lo root handle 1: htb default 12
# RUN tc class add dev lo parent 1:1 classid 1:12 htb rate ${BANDWIDTH}
# RUN tc qdisc add dev lo parent 1:12 netem delay ${LATENCY} ${JITTER} distribution normal

COPY nginx.conf /etc/nginx
RUN chmod +x ./start.sh
CMD ["./start.sh"]
#CMD ["flask", "run", "--host", "0.0.0.0"]