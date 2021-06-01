FROM yogendra/ubuntu
ADD scripts/k8s-tool-install.sh  k8s-tools-install.sh

RUN ./k8s-tools-install.sh
