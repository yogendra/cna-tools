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

set -e
echo Downloading: bosh
wget -q -O $PROJ_DIR/bin/bosh  "https://github.com/cloudfoundry/bosh-cli/releases/download/v5.3.1/bosh-cli-5.3.1-linux-amd64" 
chmod a+x $PROJ_DIR/bin/bosh 

echo Downloading: terraform
wget -q -O /tmp/terraform.zip "https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip" 
gunzip -S .zip /tmp/terraform.zip 
mv /tmp/terraform $PROJ_DIR/bin/terraform
chmod a+x $PROJ_DIR/bin/terraform 


echo Downloading: bbl
wget -q -O $PROJ_DIR/bin/bbl "https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.10.18/bbl-v6.10.18_linux_x86-64" 
chmod a+x $PROJ_DIR/bin/bbl 

echo Downloading: fly
wget -q -O $PROJ_DIR/bin/fly "https://github.com/concourse/concourse/releases/download/v4.2.1/fly_linux_amd64" 
chmod a+x $PROJ_DIR/bin/fly

echo Downloading: om
wget -q -O $PROJ_DIR/bin/om "https://github.com/pivotal-cf/om/releases/download/0.44.0/om-linux" 
chmod a+x $PROJ_DIR/bin/om 

echo Downloading: bbr
wget -q -O - "https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/download/v1.2.8/bbr-1.2.8.tar"  | tar -C /tmp -x  releases/bbr
mv /tmp/releases/bbr $PROJ_DIR/bin/bbr
chmod a+x $PROJ_DIR/bin/bbr 
rm -rf /tmp/releases 

echo Downloading: cf
wget -q -O -  "https://packages.cloudfoundry.org/stable?release=linux64-binary&source=github" | tar -C $PROJ_DIR/bin -zx cf  
chmod a+x $PROJ_DIR/bin/cf 

echo Downloading: credhub
wget -q -O - "https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.2.1/credhub-linux-2.2.1.tgz"  | tar -C /tmp -xz  ./credhub
mv /tmp/credhub $PROJ_DIR/bin/credhub
chmod a+x $PROJ_DIR/bin/credhub


echo Downloading: kubectl
wget -q -O $PROJ_DIR/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod a+x $PROJ_DIR/bin/kubectl


echo Downloading: docker
wget -q -O - "https://download.docker.com/linux/static/stable/x86_64/docker-18.09.1.tgz"  | tar -C /tmp -xz  docker/docker
mv /tmp/docker/docker $PROJ_DIR/bin/docker
chmod a+x $PROJ_DIR/bin/docker
rm -rf /tmp/docker

echo Downloading: docker-machine
wget -q -O $PROJ_DIR/bin/docker-machine  "https://github.com/docker/machine/releases/download/v0.16.0/docker-machine-$(uname -s)-$(uname -m)"
chmod a+x $PROJ_DIR/bin/docker-machine


echo Downloading: jq
wget -q -O $PROJ_DIR/bin/jq  "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
chmod a+x $PROJ_DIR/bin/jq

echo Downloading: direnv
wget -q -O $PROJ_DIR/bin/direnv  "https://github.com/direnv/direnv/releases/download/v2.19.0/direnv.linux-amd64"
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

echo Downloading: docker-compose
wget -q -O $PROJ_DIR/bin/docker-compose  "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)"
chmod a+x $PROJ_DIR/bin/docker-compose

echo Downloading: riff
wget -qO /tmp/riff.tgz "https://github.com/projectriff/riff/releases/download/v0.2.0/riff-linux-amd64.tgz"
tar -C $PROJ_DIR/bin -xz /tmp/riff.tgz ./riff
rm /tmp/riff.tgz


echo Downloading: pivnet
wget -q -O $PROJ_DIR/bin/pivnet  "https://github.com/pivotal-cf/pivnet-cli/releases/download/v0.0.55/pivnet-linux-amd64-0.0.55"
chmod a+x $PROJ_DIR/bin/pivnet
$PROJ_DIR/bin/pivnet login --api-token=$PIVNET_TOKEN

echo PivNet Download: PKS client
pivnet dlpf -p pivotal-container-service -r 1.2.1 -i 239440 -d /tmp --accept-eula 
mv /tmp/pks-linux-amd64-1.2.1-build.* $PROJ_DIR/bin/pks   
chmod a+x $PROJ_DIR/bin/pks

echo PivNet Download: PFS client
pivnet dlpf -p pivotal-function-service  -r "alpha v0.1.0 " -i 268754  -d /tmp --accept-eula
tar -C $PROJ_DIR/bin -xzvf /tmp/pfs-cli-linux-amd64-20181128193639-e5de84d12d10a060aeb595310decbe7409467c99.tgz ./pfs
rm /tmp/pfs-cli-linux-amd64-20181128193639-e5de84d12d10a060aeb595310decbe7409467c99.tgz
chmod a+x $PROJ_DIR/bin/pfs



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