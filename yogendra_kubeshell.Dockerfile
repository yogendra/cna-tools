FROM yogendra/ubuntu
ADD scripts/k8s-tools-install.sh  k8s-tools-install.sh

RUN ./k8s-tools-install.sh
