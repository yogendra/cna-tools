FROM yogendra/ubuntu:user

USER root
RUN curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/bin/kubectl && chmod a+x /usr/bin/kubectl

ADD scripts/generate-kubeconfig-from-sa.sh /usr/bin/

USER ubuntu
