FROM ubuntu
ADD config/sources.list /etc/apt/sources.list

RUN apt update && \
    apt install -y  netcat inetutils-traceroute inetutils-ping net-tools netcat dnsutils wget curl

RUN curl -vvv http://secrets-server/README.md

CMD ["bash", "-l"]
