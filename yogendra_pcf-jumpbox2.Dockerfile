FROM ubuntu:bionic as base

ADD config/sources.list /etc/apt/sources.list

RUN set -e && \
    # apt update && \
    # apt -qqy install curl wget sudo && \
    adduser --disabled-password --gecos '' pcf && \
    adduser pcf sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pcf
ENV PROJ_DIR=/home/pcf
WORKDIR /home/pcf

FROM base


RUN --mount=type=secret,id=jumbox-secrets,dst=/home/pcf/secrets.sh \    
    ls -la \
    cat secrets.sh 

RUN env > text.txt \
    env

VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
