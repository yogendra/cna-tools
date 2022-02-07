FROM lscr.io/linuxserver/webtop:ubuntu-xfce

LABEL org.opencontainers.image.description Browser based GUI Jumpbox 
LABEL org.opencontainers.image.source  https://github.com/yogendra/cna-tools/blob/main/yogendra/webtop/Dockerfile
LABEL org.opencontainers.image.vendor Yogi Rampuria (@yogendra)
LABEL org.opencontainers.image.title  yogendra/webtop
LABEL org.opencontainers.image.source https://github.com/yogendra/cna-tools

RUN  curl -sSL https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/jumpbox-init.sh | bash -s -- common k8s azure aws gcp

