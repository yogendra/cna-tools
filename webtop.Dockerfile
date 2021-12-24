FROM lscr.io/linuxserver/webtop:ubuntu-xfce

RUN  curl -sSL https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/jumpbox-init.sh | bash -s -- common k8s azure aws gcp

