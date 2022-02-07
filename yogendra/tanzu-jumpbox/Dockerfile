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

RUN --mount=type=secret,id=jumpbox-secrets,dst=/home/ubuntu/secrets.sh \
    eval $(sudo cat /home/ubuntu/secrets.sh) && \    
    /home/ubuntu/scripts/tanzu-jumpbox-init.sh && \
    /home/ubuntu/scripts/k8s-tools-install.sh && \
    sudo rm -rf /var/lib/apt/lists/* 

