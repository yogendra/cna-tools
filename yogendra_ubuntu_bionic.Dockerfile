FROM ubuntu:bionic
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y  netcat inetutils-traceroute inetutils-ping net-tools netcat dnsutils wget curl unzip

CMD ["bash", "-l"]