FROM yogendra/ubuntu
LABEL org.opencontainers.image.source https://github.com/yogendra/cna-tools
ADD --chown=ubuntu scripts/k8s-tools-install.sh  k8s-tools-install.sh

RUN ./k8s-tools-install.sh
