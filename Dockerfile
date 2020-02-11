FROM ubuntu:latest
ARG build_secret_location=http://secrets-server/secrets.txt
ADD sources.list /etc/apt/source.list

RUN set -e && \
    apt update && \
    apt -qqy install sudo wget && \
    adduser --disabled-password --gecos '' pcf && \
    adduser pcf sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pcf
WORKDIR /home/pcf

ENV PROJ_DIR=/home/pcf  

VOLUME /home/pcf/workspace

RUN set -e &&\
    eval $(wget -qO- $build_secret_location) && \
    wget -qO- "${GIST_URL}/raw/jumpbox-init.sh?$RANDOM" | bash && \
    sudo rm -rf /var/lib/apt/lists/* 