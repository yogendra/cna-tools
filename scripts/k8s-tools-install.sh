#!/usr/bin/env bash

set -Eeuo pipefail

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list


sudo apt-get update
sudo apt-get install -y kubectl

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
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)

kubectl krew install access-matrix cert-manager ctx konfig ns tail  || echo "[WARNING] Some plugins were not installed"
