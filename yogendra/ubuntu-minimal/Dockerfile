FROM ubuntu:latest

RUN adduser --shell /bin/bash --uid 1000 --disabled-login  --gecos "" ubuntu
RUN set -e && \
  adduser ubuntu sudo && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER 1000
RUN mkdir $HOME/bin && \
  export PATH=$HOME/bin:$PATH && \
  echo 'export PATH=$HOME/bin:$PATH'>> ~/.bash_profile
  
WORKDIR /home/ubuntu
