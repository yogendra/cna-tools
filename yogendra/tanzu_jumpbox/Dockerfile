FROM yogendra/ubuntu as base


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

