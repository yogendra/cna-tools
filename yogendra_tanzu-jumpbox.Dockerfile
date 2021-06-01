FROM yogendra/ubuntu as base

ENV PROJ_DIR=/home/ubuntu
ENV TANZU_TOOLS_DIR=/home/ubuntu

ADD scripts scripts
ADD config config

USER root
RUN mkdir -p /home/ubuntu/workspace ; chown -R ubuntu /home/ubuntu/workspace

VOLUME /home/ubuntu/workspace

USER ubuntu
RUN --mount=type=secret,id=jumpbox-secrets,dst=/home/ubuntu/secrets.sh \
    eval $(sudo cat /home/ubuntu/secrets.sh) && \        
    scripts/tanzu-jumpbox-init.sh && \
    scripts/k8s-tools-install.sh && \
    sudo rm -rf /var/lib/apt/lists/* 

