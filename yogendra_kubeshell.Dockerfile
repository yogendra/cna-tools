FROM yogendra/ubuntu

RUN set -e && \
  curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o $HOME/bin/kubectl && chmod a+x $HOME/bin/kubectl && \
  export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.krew/bin:$PATH && \
  echo 'export PATH=$HOME/bin:$HOME/.local/bin:$HOME/.krew/bin:$PATH' >> ~/.bash_profile && \
  echo 'alias k=kubectl' >> ~/.bash_profile && \
  echo 'source <(kubectl completion bash)' >> ~/.bash_profile && \
  echo 'complete -F __start_kubectl k' >> ~/.bash_profile && \
  echo 'alias kns="kubectl ns"' >> ~/.bash_profile && \
  echo 'alias kctx="kubectl ctx"' >> ~/.bash_profile && \  
  wget -O- https://carvel.dev/install.sh | K14SIO_INSTALL_BIN_DIR=$HOME/bin bash && \
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | HELM_INSTALL_DIR=$HOME/bin bash && \
  curl -sS https://webinstall.dev/k9s | bash && \
  curl -sS https://webinstall.dev/bat | bash && \
  curl -sS https://webinstall.dev/jq | bash && \
  rm -rf $HOME/Downloads && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" && \
  KREW=./krew-"${OS}_${ARCH}" && \
  tar zxvf krew.tar.gz "$KREW" && \
  "$KREW" install krew && \
  rm krew.tar.gz "$KREW" && \
  kubectl krew install access-matrix cert-manager ctx konfig ns tail
