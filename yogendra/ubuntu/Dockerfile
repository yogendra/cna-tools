FROM ubuntu:latest
LABEL org.opencontainers.image.description Ubuntu based workspace image
LABEL org.opencontainers.image.source  https://github.com/yogendra/cna-tools/blob/main/yogendra/ubuntu/Dockerfile
LABEL org.opencontainers.image.vendor Yogi Rampuria (@yogendra)
LABEL org.opencontainers.image.title  yogendra/ubuntu
LABEL org.opencontainers.image.source https://github.com/yogendra/cna-tools

ENV TIMEZONE=Asia/Singapore

RUN set -e && \
    ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    apt update && \
    apt install -qqy \
        ca-certificates && \
    apt upgrade -qqy && \
    apt install -qqy \
        apt-transport-https \ 
        curl \
        dnsutils \
        direnv \
        git \
        gnupg \
        inetutils-traceroute \
        inetutils-ping \
        net-tools \
        netcat \
        lsb-release \
        sudo \
        tmux \
        tcpdump \
        unzip \
        vim  \
        wget && \
    rm -rf /var/lib/apt/lists/* 

RUN adduser --shell /bin/bash --uid 1000 --disabled-login  --gecos "" ubuntu
RUN set -e && \
  adduser ubuntu sudo && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER 1000
RUN mkdir $HOME/bin && \
  export PATH=$HOME/bin:$PATH && \
  echo 'export PATH=$HOME/bin:$PATH'>> ~/.bash_profile
  
WORKDIR /home/ubuntu

RUN curl -sSL https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/dotfiles-init.Linux.sh  | bash 

CMD ["bash", "-l"]
