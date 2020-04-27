FROM alpine
ARG url=http://secrets-server:80/README.md

ADD config/sources.list /etc/apt/sources.list

RUN wget -S -O- $url
