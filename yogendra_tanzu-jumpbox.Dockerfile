FROM yogendra/ubuntu as base

ENV PROJ_DIR=/home/ubuntu
ENV tanzu_TOOLS_DIR=/home/ubuntu

ADD scripts scripts
ADD config config
RUN --mount=type=secret,id=jumpbox-secrets,dst=/home/ubuntu/secrets.sh \
    eval $(sudo cat /home/ubuntu/secrets.sh) && \        
    # scripts/tanzu-jumpbox-init.sh && \
    sudo rm -rf /var/lib/apt/lists/* 

VOLUME /home/ubuntu/workspace
