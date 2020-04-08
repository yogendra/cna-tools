FROM ubuntu:latest as base

ADD config/sources.list /etc/apt/sources.list

RUN set -e && \
    apt update && \
    apt -qqy install wget sudo && \
    adduser --disabled-password --gecos '' pcf && \
    adduser pcf sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pcf
ENV PROJ_DIR=/home/pcf
WORKDIR /home/pcf

FROM base
ARG build_secrets_location=http://secrets-server/config/secrets.sh


RUN set -e &&\    
    eval "$(wget -qO- $build_secrets_location)" && \ 
    wget -qO- "https://raw.githubusercontent.com/$GITHUB_REPO/master/scripts/pcf-jumpbox-init.sh?$RANDOM" | bash  &&\
    sudo rm -rf /var/lib/apt/lists/* 


VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
