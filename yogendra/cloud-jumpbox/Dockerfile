FROM yogendra/ubuntu as base
LABEL org.opencontainers.image.description Tanzu Jumpbox - All the toosl for workign with tanzu products
LABEL org.opencontainers.image.source  https://github.com/yogendra/cna-tools/blob/main/yogendra/tanzu-jumpbox/Dockerfile
LABEL org.opencontainers.image.vendor Yogi Rampuria (@yogendra)
LABEL org.opencontainers.image.title  yogendra/tanzu-jumpbox
LABEL org.opencontainers.image.source https://github.com/yogendra/cna-tools

ENV PROJ_DIR=/home/ubuntu
ENV TANZU_TOOLS_DIR=/home/ubuntu

USER 1000
COPY --chown=1000 scripts/* scripts/
COPY --chown=1000 config/* config/

RUN mkdir -p /home/ubuntu/workspace 

VOLUME /home/ubuntu/workspace

RUN  curl -sSL https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/jumpbox-init.sh | bash -s -- common k8s azure aws gcp profile

