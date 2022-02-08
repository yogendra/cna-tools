FROM yogendra/ubuntu

LABEL org.opencontainers.image.description KubeShell - Shell Swiss Knife for Kubernetes
LABEL org.opencontainers.image.source  https://github.com/yogendra/cna-tools/blob/main/yogendra/kubeshell/Dockerfile
LABEL org.opencontainers.image.vendor Yogi Rampuria (@yogendra)
LABEL org.opencontainers.image.title  yogendra/kubeshell
LABEL org.opencontainers.image.source https://github.com/yogendra/cna-tools

ADD --chown=ubuntu scripts/k8s-tools-install.sh  k8s-tools-install.sh

RUN  curl -sSL https://raw.githubusercontent.com/yogendra/dotfiles/master/scripts/jumpbox-init.sh | bash -s -- k8s


