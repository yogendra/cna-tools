#!/usr/bin/env bash
# Set 2 Environment variables
#  PROJ_DIR : Project Directory. All tools will get install under PROJ_DIR/bin. (defaults: /usr/local)
#  PIVNET_TOKEN: Pivotal Network Token (required) Its **NOT** ending with -r. It looks like DJHASLD7_HSDHA7
# Run 
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init.sh"  | PIVNET_TOKEN=DJHASLD7_HSDHA7 bash
# Or to put binaries at your preferred location (example: /home/me/bin), provide PROD_DIR
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init.sh"  | PIVNET_TOKEN=DJHASLD7_HSDHA7 PROJ_DIR=/home/yrampuria bash
PROJ_DIR=${PROJ_DIR:-/usr/local}
PIVNET_TOKEN=${PIVNET_TOKEN}
[[ -z $PIVNET_TOKEN ]] && echo "PIVNET_TOKEN environment variable not set. See instructions at https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec#jumpbox-init-sh" && exit 1
echo PROJ_DIR=$PROJ_DIR
[[ -d $PROJ_DIR/bin ]]  || mkdir -p $PROJ_DIR/bin
GIST=https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec

cat <<EOF
========================================================================
General Instrucations
========================================================================
  Add following line to .profile/.bash_profile
  export PATH=$PROJ_DIR/bin:\$PATH

========================================================================
EOF

# Get updated url at https://github.com/cloudfoundry/bosh-cli/releases/latest
URL="https://github.com/cloudfoundry/bosh-cli/releases/download/v6.1.0/bosh-cli-6.1.0-linux-amd64"
set -e
echo Downloading: bosh
wget -q $URL -O $PROJ_DIR/bin/bosh
chmod a+x $PROJ_DIR/bin/bosh 

# Get updated url at https://www.terraform.io/downloads.html
URL="https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip"
echo Downloading: terraform
wget -q $URL -O /tmp/terraform.zip
gunzip -S .zip /tmp/terraform.zip 
mv /tmp/terraform $PROJ_DIR/bin/terraform
chmod a+x $PROJ_DIR/bin/terraform 

# Get updated url at https://github.com/cloudfoundry/bosh-bootloader/releases/latest
URL="https://github.com/cloudfoundry/bosh-bootloader/releases/download/v8.3.1/bbl-v8.3.1_linux_x86-64" 
echo Downloading: bbl
wget -q $URL -O $PROJ_DIR/bin/bbl
chmod a+x $PROJ_DIR/bin/bbl 


# Get updated url at https://github.com/concourse/concourse/releases/latest
URL="https://github.com/concourse/concourse/releases/download/v5.6.0/fly-5.6.0-linux-amd64.tgz" 
echo Downloading: fly
wget -q $URL -O- | tar -C $PROJ_DIR/bin -zx fly  
chmod a+x $PROJ_DIR/bin/fly

# Get updated url at https://github.com/pivotal-cf/om/releases/latest
URL="https://github.com/pivotal-cf/om/releases/download/4.2.0/om-linux-4.2.0.tar.gz" 
echo Downloading: om
wget -q $URL -O- | tar -C $PROJ_DIR/bin -zx om
chmod a+x $PROJ_DIR/bin/om 

# Get updated url at https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/latest
URL="https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v1.5.2/bbr-1.5.2-linux-amd64"
echo Downloading: bbr
wget -q $URL -O $PROJ_DIR/bin/bbr 
chmod a+x $PROJ_DIR/bin/bbr

# Always updated version :D
# Get updated url at https://docs.cloudfoundry.org/cf-cli/install-go-cli.html#pkg-linux
URL="https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.47.0&source=github-rel"
echo Downloading: cf
wget -q $URL  -O- | tar -C $PROJ_DIR/bin -zx cf  
chmod a+x $PROJ_DIR/bin/cf 

# Get updated url at https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest
URL="https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.6.0/credhub-linux-2.6.0.tgz" 
echo Downloading: credhub
wget -q $URL -O- | tar -C $PROJ_DIR/bin -xz  ./credhub
chmod a+x $PROJ_DIR/bin/credhub


# Always updated version :D
# Get updated url at https://storage.googleapis.com/kubernetes-release/release/stable.txt
URL="https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
echo Downloading: kubectl
wget -q $URL -O $PROJ_DIR/bin/kubectl
chmod a+x $PROJ_DIR/bin/kubectl


# Get updated url at https://download.docker.com/linux/static/stable/x86_64/
URL="https://download.docker.com/linux/static/stable/x86_64/docker-19.03.3.tgz"
echo Downloading: docker
wget -q $URL -O- | tar -C /tmp -xz  docker/docker
mv /tmp/docker/docker $PROJ_DIR/bin/docker
chmod a+x $PROJ_DIR/bin/docker
rm -rf /tmp/docker

# Get updated url at https://github.com/docker/machine/releases/latest
URL="https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(uname -s)-$(uname -m)"
echo Downloading: docker-machine
wget -q $URL  -O $PROJ_DIR/bin/docker-machine
chmod a+x $PROJ_DIR/bin/docker-machine

# Get updated url at "https://github.com/stedolan/jq/releases/latest
URL="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
echo Downloading: jq
wget -q $URL -O $PROJ_DIR/bin/jq
chmod a+x $PROJ_DIR/bin/jq

# Get updated url at "https://github.com/pivotal-cf/texplate/releases/latest
URL="https://github.com/pivotal-cf/texplate/releases/download/v0.3.0/texplate_linux_amd64"
echo Downloading: texplate
wget -q $URL -O $PROJ_DIR/bin/texplate
chmod a+x $PROJ_DIR/bin/texplate


# Get updated url at https://github.com/docker/compose/releases/latest
URL="https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)"
echo Downloading: docker-compose
wget -q $URL -O $PROJ_DIR/bin/docker-compose
chmod a+x $PROJ_DIR/bin/docker-compose

# Get updated url at https://github.com/projectriff/riff/releases/latest
URL="https://github.com/projectriff/riff/releases/download/v0.4.0/riff-linux-amd64.tgz"
echo Downloading: riff
wget -q $URL -O- | tar -C $PROJ_DIR/bin -xz ./riff
chmod a+x $PROJ_DIR/bin/riff

# Get updated url at https://github.com/cloudfoundry-incubator/uaa-cli/releases/tag/0.8.0
URL="https://github.com/cloudfoundry-incubator/uaa-cli/releases/download/0.8.0/uaa-linux-amd64-0.8.0"
echo Downloading: uaac
wget -q $URL -O $PROJ_DIR/bin/uaac
chmod a+x $PROJ_DIR/bin/uaac


# Get updated url at https://github.com/pivotal-cf/pivnet-cli/releases/latest
URL="https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.68/pivnet-linux-amd64-0.0.68"
echo Downloading: pivnet
wget -q $URL -O $PROJ_DIR/bin/pivnet
chmod a+x $PROJ_DIR/bin/pivnet
# $PROJ_DIR/bin/pivnet login --api-token=$PIVNET_TOKEN

# Get updated url at https://network.pivotal.io/products/pivotal-container-service/
VERSION=1.5.1
echo PivNet Download: PKS client
om download-product --pivnet-file-glob='pks-linux-amd64-*' -v "$VERSION" -t $PIVNET_TOKEN -p pivotal-container-service -o /tmp
mv /tmp/pks-linux-amd64-* $PROJ_DIR/bin/pks
chmod a+x $PROJ_DIR/bin/pks

# Get updated url at https://network.pivotal.io/products/pivotal-function-service/
VERSION="alpha v0.4.0"
echo PivNet Download: PFS client
om download-product -o /tmp -t $PIVNET_TOKEN -p pivotal-function-service --pivnet-file-glob='pfs-cli-linux-amd64-*' -v "$VERSION" 
mv /tmp/pfs-cli-linux-amd64-* $PROJ_DIR/bin/pfs
chmod a+x $PROJ_DIR/bin/pfs

om download-product -o /tmp -t $PIVNET_TOKEN -p pivotal-function-service --pivnet-file-glob='duffle-linux-*' -v "$VERSION" 
mv /tmp/duffle-linux-* $PROJ_DIR/bin/duffle
chmod a+x $PROJ_DIR/bin/duffle

# Get updated url at https://github.com/sharkdp/bat/releases/latest
URL=https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-v0.12.1-x86_64-unknown-linux-gnu.tar.gz
echo Downloading: bat
wget -q  $URL -O- | tar -C /tmp -xz bat-v0.12.1-x86_64-unknown-linux-gnu/bat
mv /tmp/bat-*/bat $PROJ_DIR/bin/bat
chmod a+x  $PROJ_DIR/bin/bat


# Get updated url at https://github.com/direnv/direnv/releases/latest
URL="https://github.com/direnv/direnv/releases/download/v2.20.0/direnv.linux-amd64"
echo Downloading: direnv
wget -q  $URL -O $PROJ_DIR/bin/direnv
chmod a+x $PROJ_DIR/bin/direnv

wget -q "${GIST}/raw/.direnvrc" -O $HOME/.direnvrc

cat <<EOF
========================================================================
direnv: Additional Instrucations
========================================================================
  Add following lines to .profile/.bash_profile
  export PATH=$PROJ_DIR/bin:\$PATH
  eval "\$(direnv hook bash)"
========================================================================
EOF

# Get updated url at https://network.pivotal.io/products/p-scheduler
VERSION=1.2.28
echo PivNet Download: Scheduler CF CLI Plugin
om download-product --pivnet-file-glob='scheduler-for-pcf-cliplugin-linux64-binary-*'  -v $VERSION  -t $PIVNET_TOKEN -p p-scheduler -o /tmp
cf install-plugin -f /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*
   
# Get updated url at https://network.pivotal.io/products/pcf-app-autoscaler
VERSION=2.0.199
echo PivNet Download: App Autoscaler CF CLI Plugin
om download-product --pivnet-file-glob='autoscaler-for-pcf-cliplugin-linux64-binary-*' -v $VERSION  -t $PIVNET_TOKEN -p pcf-app-autoscaler -o /tmp
cf install-plugin -f /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*

# Get updated url at https://network.pivotal.io/products/p-event-alerts
VERSION=1.2.8
echo PivNet Download: Event Alerts CF CLI Plugin
om download-product --pivnet-file-glob='pcf-event-alerts-cli-plugin-linux64-binary-*' -v $VERSION -t $PIVNET_TOKEN -p p-event-alerts -o /tmp
cf install-plugin -f /tmp/pcf-event-alerts-cli-plugin-linux64-binary-*
rm /tmp/pcf-event-alerts-cli-plugin-linux64-binary-*


mkdir -p .vim/autoload
wget -q "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O $HOME/.vim/autoload/plug.vim 
wget -q "${GIST}/raw/.vimrc" -O $HOME/.vimrc

echo Setting TMUX
wget -q "${GIST}/raw/.tmux.conf" -O $HOME/.tmux.conf

echo Put SSH keys
wget -q $GIST/raw/keys | while read key; do
  wget -qO - "$key" >> $HOME/.ssh/authorized_keys
done

cat <<EOF
========================================================================
SSH Config
========================================================================
To generate new keys and setup passwordless login run:
ssh-keygen  -q -t rsa -N ""
ssh-keygen  -q -t dsa -N ""
cat ~/.ssh/*.pub >> $HOME/.ssh/authorized_keys
EOF


echo Done
