FROM ubuntu:bionic as base

ADD config/sources.list /etc/apt/sources.list

RUN set -e && \
    apt update && \
    apt -qqy install curl wget sudo && \
    adduser --disabled-password --gecos '' pcf && \
    adduser pcf sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER pcf
ENV PROJ_DIR=/home/pcf
WORKDIR /home/pcf

FROM base
ARG build_secrets_location=http://secrets/config/secrets.sh

RUN wget -qO- $build_secrets_location 

RUN echo loading secrets from $build_secrets_location && \
    eval "$(wget -qO- $build_secrets_location)" && \
    echo Getting init script from : "https://raw.githubusercontent.com/$GITHUB_REPO/master/scripts/pcf-jumpbox-init.sh?$RANDOM" && \
    wget -q "https://raw.githubusercontent.com/$GITHUB_REPO/master/scripts/pcf-jumpbox-init.sh?$RANDOM" -o /tmp/init.sh && \
    chmod a+x /tmp/init.sh

RUN /tmp/init.sh

RUN sudo rm -rf /var/lib/apt/lists/* 


VOLUME /home/pcf/workspace

# Keep container running as daemon
CMD tail -f /dev/null
