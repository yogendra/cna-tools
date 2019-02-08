#!/usr/bin/env bash
# Set 2 Environment variables
#  PROJ_DIR : Project Directory. All tools will get install under PROJ_DIR/bin. (defaults: /usr/local)
#  PIVNET_TOKEN: Pivotal Network Token (required)
# Run 
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init"  | PIVNET_TOKEN=56789fghy-r bash
# Or to put binaries at your preferred location (example: /home/me/bin), provide PROD_DIR
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init"  | PIVNET_TOKEN=76897tyfgdghkj-r PROJ_DIR=/home/yrampuria bash
PROJ_DIR=${PROJ_DIR:-/usr/local}
PIVNET_TOKEN=${PIVNET_TOKEN}
[[ -z $PIVNET_TOKEN ]] && echo "PIVNET_TOKEN environment variable not set. See instructions at https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec#jumpbox-init-sh" && exit 1
echo PROJ_DIR=$PROJ_DIR
[[ -d $PROJ_DIR/bin ]]  || mkdir -p $PROJ_DIR/bin

cat <<EOF
========================================================================
General Instrucations
========================================================================
  Add following line to .profile/.bash_profile
  export PATH=$PROJ_DIR/bin:\$PATH

========================================================================
EOF

# Get updated url at https://github.com/cloudfoundry/bosh-cli/releases/latest
URL="https://github.com/cloudfoundry/bosh-cli/releases/download/v5.4.0/bosh-cli-5.4.0-linux-amd64"
set -e
echo Downloading: bosh
wget -q -O $PROJ_DIR/bin/bosh  $URL
chmod a+x $PROJ_DIR/bin/bosh 

# Get updated url at https://www.terraform.io/downloads.html
URL="https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip"
echo Downloading: terraform
wget -q -O /tmp/terraform.zip $URL
gunzip -S .zip /tmp/terraform.zip 
mv /tmp/terraform $PROJ_DIR/bin/terraform
chmod a+x $PROJ_DIR/bin/terraform 

# Get updated url at https://github.com/cloudfoundry/bosh-bootloader/releases/latest
URL="https://github.com/cloudfoundry/bosh-bootloader/releases/download/v7.0.13/bbl-v7.0.13_linux_x86-64" 
echo Downloading: bbl
wget -q -O $PROJ_DIR/bin/bbl $URL
chmod a+x $PROJ_DIR/bin/bbl 


# Get updated url at https://github.com/concourse/concourse/releases/latest
URL="https://github.com/concourse/concourse/releases/download/v4.2.2/fly_linux_amd64" 
echo Downloading: fly
wget -q -O $PROJ_DIR/bin/fly $URL
chmod a+x $PROJ_DIR/bin/fly

# Get updated url at https://github.com/pivotal-cf/om/releases/latest
URL="https://github.com/pivotal-cf/om/releases/download/0.51.0/om-linux" 
echo Downloading: om
wget -q -O $PROJ_DIR/bin/om $URL
chmod a+x $PROJ_DIR/bin/om 

# Get updated url at https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/latest
URL="https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v1.3.2/bbr-1.3.2-linux-amd64"
echo Downloading: bbr
wget -q -O $PROJ_DIR/bin/bbr $URL
chmod a+x $PROJ_DIR/bin/bbr

# Always updated version :D
# Get updated url at https://docs.cloudfoundry.org/cf-cli/install-go-cli.html#pkg-linux
URL="https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github"
echo Downloading: cf
wget -q -O -  $URL | tar -C $PROJ_DIR/bin -zx cf  
chmod a+x $PROJ_DIR/bin/cf 

# Get updated url at https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest
URL="https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.1/credhub-linux-2.2.1.tgz" 
echo Downloading: credhub
wget -q -O - $URL | tar -C /tmp -xz  ./credhub
mv /tmp/credhub $PROJ_DIR/bin/credhub
chmod a+x $PROJ_DIR/bin/credhub


# Always updated version :D
# Get updated url at https://storage.googleapis.com/kubernetes-release/release/stable.txt
URL="https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
echo Downloading: kubectl
wget -q -O $PROJ_DIR/bin/kubectl $URL
chmod a+x $PROJ_DIR/bin/kubectl


# Get updated url at https://download.docker.com/linux/static/stable/x86_64/
URL="https://download.docker.com/linux/static/stable/x86_64/docker-18.09.1.tgz"
echo Downloading: docker
wget -q -O - $URL  | tar -C /tmp -xz  docker/docker
mv /tmp/docker/docker $PROJ_DIR/bin/docker
chmod a+x $PROJ_DIR/bin/docker
rm -rf /tmp/docker

# Get updated url at https://github.com/docker/machine/releases/latest
URL="https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-$(uname -s)-$(uname -m)"
echo Downloading: docker-machine
wget -q -O $PROJ_DIR/bin/docker-machine  $URL
chmod a+x $PROJ_DIR/bin/docker-machine

# Get updated url at "https://github.com/stedolan/jq/releases/latest
URL="https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
echo Downloading: jq
wget -q -O $PROJ_DIR/bin/jq  $URL
chmod a+x $PROJ_DIR/bin/jq

# Get updated url at https://github.com/docker/compose/releases/latest
URL="https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)"
echo Downloading: docker-compose
wget -q -O $PROJ_DIR/bin/docker-compose  $URL
chmod a+x $PROJ_DIR/bin/docker-compose

# Get updated url at https://github.com/projectriff/riff/releases/latest
URL="https://github.com/projectriff/riff/releases/download/v0.2.0/riff-linux-amd64.tgz"
echo Downloading: riff
wget -qO /tmp/riff.tgz $URL
tar -C $PROJ_DIR/bin -xzf /tmp/riff.tgz ./riff
rm /tmp/riff.tgz

# Get updated url at https://github.com/pivotal-cf/pivnet-cli/releases/latest
URL="https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.55/pivnet-linux-amd64-0.0.55"
echo Downloading: pivnet
wget -q -O $PROJ_DIR/bin/pivnet  $URL
chmod a+x $PROJ_DIR/bin/pivnet
# $PROJ_DIR/bin/pivnet login --api-token=$PIVNET_TOKEN

# Get updated url at https://network.pivotal.io/products/pivotal-container-service/
VERSION=1.3.0
echo PivNet Download: PKS client
om download-product --pivnet-file-glob='pks-linux-amd64-*' -v $VERSION -t $PIVNET_TOKEN -p pivotal-container-service -o /tmp
mv /tmp/pks-linux-amd64-* $PROJ_DIR/bin/pks
chmod a+x $PROJ_DIR/bin/pks


# Get updated url at https://network.pivotal.io/products/p-scheduler
VERSION=1.2.5
echo PivNet Download: Scheduler CF CLI Plugin
om download-product --pivnet-file-glob='scheduler-for-pcf-cliplugin-linux64-binary-*'  -v $VERSION  -t $PIVNET_TOKEN -p p-scheduler -o /tmp
cf install-plugin -f /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*
   
# Get updated url at https://network.pivotal.io/products/pcf-app-autoscaler
VERSION=2.0.91
echo PivNet Download: App Autoscaler CF CLI Plugin
om download-product --pivnet-file-glob='autoscaler-for-pcf-cliplugin-linux64-binary-*' -v $VERSION  -t $PIVNET_TOKEN -p pcf-app-autoscaler -o /tmp
cf install-plugin -f /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*

# Get updated url at https://network.pivotal.io/products/p-event-alerts
VERSION=1.2.6
echo PivNet Download: Event Alerts CF CLI Plugin
om download-product --pivnet-file-glob='linux64-*' -v $VERSION -t $PIVNET_TOKEN -p p-event-alerts -o /tmp
cf install-plugin -f /tmp/linux64-*
rm /tmp/linux64-*

# Get updated url at https://network.pivotal.io/products/pivotal-function-service/
# VERSION=0.1.0
# echo PivNet Download: PFS client
# om download-product --pivnet-file-glob='pfs-cli-linux-amd64-*' -v $VERSION -t $PIVNET_TOKEN -p pivotal-function-service -o /tmp
# tar -C $PROJ_DIR/bin -xzvf /tmp/pfs-cli-linux-amd64-*.tgz ./pfs
# rm /tmp/pfs-cli-linux-amd64-*.tgz
# chmod a+x $PROJ_DIR/bin/pfs


# Get updated url at https://github.com/direnv/direnv/releases/latest
URL="https://github.com/direnv/direnv/releases/download/v2.19.1/direnv.linux-amd64"
echo Downloading: direnv
wget -q -O $PROJ_DIR/bin/direnv  $URL

chmod a+x $PROJ_DIR/bin/direnv
wget -qO - "https://gist.githubusercontent.com/yogendra/7d23440d2d139cf8d426/raw/direnvrc" >> $HOME/.direnvrc
cat <<EOF
========================================================================
direnv: Additional Instrucations
========================================================================
  Add following lines to .profile/.bash_profile
  export PATH=$PROJ_DIR/bin:\$PATH
  eval "\$(direnv hook bash)"
========================================================================
EOF

echo Setting Up UAAC
sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev unzip
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
echo 'eval $(rbenv init -)' >> ~/.profile
eval "$(~/.rbenv/bin/rbenv init -)"
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
rbenv install 2.4.1
rbenv global 2.4.1
rbenv rehash
gem install cf-uaac


echo Put SSH keys
wget -qO - "https://gist.githubusercontent.com/yogendra/c3ebfc2f5c1bccee7da9c427dad2a472/raw/gandiv.pub" >> $HOME/.ssh/authorized_keys
wget -qO - "https://gist.githubusercontent.com/yogendra/c3ebfc2f5c1bccee7da9c427dad2a472/raw/mbp15.pub" >> $HOME/.ssh/authorized_keys
wget -qO - "https://gist.githubusercontent.com/yogendra/c3ebfc2f5c1bccee7da9c427dad2a472/raw/parasu.pub" >> $HOME/.ssh/authorized_keys
wget -qO - "https://gist.githubusercontent.com/yogendra/c3ebfc2f5c1bccee7da9c427dad2a472/raw/pinaka.pub" >> $HOME/.ssh/authorized_keys
ssh-keygen  -q -t rsa -N ""
ssh-keygen  -q -t dsa -N ""
cat <<EOF
========================================================================
SSH Config
========================================================================
 New Keys generated. Here are the public keys for passwordless access

EOF

cat $HOME/.ssh/*.pub 

echo ========================================================================

chmod 600 $HOME/.ssh/authorized_keys

echo Setup VIM
mkdir -p .vim/autoload
wget -qO $HOME/.vim/autoload/plug.vim "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
wget -qO $HOME/.vimrc "https://gist.githubusercontent.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/vimrc"    

echo Setting TMUX
echo "new-session" > $HOME/.tmux.conf


echo Done