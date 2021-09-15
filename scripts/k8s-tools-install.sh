#!/usr/bin/env bash

curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o $HOME/bin/kubectl 
chmod a+x $HOME/bin/kubectl

cat <<EOF >> ~/.bashrc
export PATH=$HOME/.local/bin:$HOME/.krew/bin:$PATH
alias k=kubectl
source <(kubectl completion bash)
complete -F __start_kubectl k
alias kns="kubectl ns"
alias kctx="kubectl ctx" 
EOF
source ~/.bashrc
 
wget -O- https://carvel.dev/install.sh | K14SIO_INSTALL_BIN_DIR=$HOME/bin bash
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | HELM_INSTALL_DIR=$HOME/bin bash
curl -sS https://webinstall.dev/k9s | bash 
rm -rf $HOME/Downloads/*.tar.gz
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"${OS}_${ARCH}" &&
  "$KREW" install krew
)

kubectl krew install access-matrix cert-manager ctx konfig ns tail
