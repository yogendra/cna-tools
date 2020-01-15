#!/usr/bin/env bash
# Set 2 Environment variables
#  PROJ_DIR : Project Directory. All tools will get install under PROJ_DIR/bin. (defaults: /usr/local)
#  OM_PIVNET_TOKEN: Pivotal Network Token (required) Its **NOT** ending with -r. It looks like DJHASLD7_HSDHA7
# Run
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init.sh?nocache"  | OM_PIVNET_TOKEN=DJHASLD7_HSDHA7 bash
# Or to put binaries at your preferred location (example: /home/me/bin), provide PROD_DIR
# wget -qO- "https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec/raw/jumpbox-init.sh?nocache"  | OM_PIVNET_TOKEN=DJHASLD7_HSDHA7 PROJ_DIR=/home/yrampuria bash


PROJ_DIR=${PROJ_DIR:-/usr/local}
export PATH=$PATH:$PROJ_DIR/bin
function log {
  echo $*  1>&2
}

OM_PIVNET_TOKEN=${OM_PIVNET_TOKEN}
[[ -z $OM_PIVNET_TOKEN ]] && log "OM_PIVNET_TOKEN environment variable not set. See instructions at https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec#jumpbox-init-sh" && exit 1
log PROJ_DIR=$PROJ_DIR
[[ -d $PROJ_DIR/bin ]]  || mkdir -p $PROJ_DIR/bin
GIST=https://gist.github.com/yogendra/318c09f0cd2548bdd07f592722c9bbec



cat <<EOF
========================================================================
General Instructions
========================================================================
  Add following line to .profile/.bash_profile
  export PATH=$PROJ_DIR/bin:\$PATH

========================================================================
EOF

# Get updated url at "https://github.com/stedolan/jq/releases/latest
VERSION=$(curl -s https://api.github.com/repos/stedolan/jq/releases/latest | grep tag_name | sed -E  's/.*: "(.*)",/\1/')
URL="https://github.com/stedolan/jq/releases/download/$VERSION/jq-linux64"
log Downloading: jq from $URL $VERSIONqq
wget -q $URL -O $PROJ_DIR/bin/jq
chmod a+x $PROJ_DIR/bin/jq
alias jq=$PROJ_DIR/bin/jq

VERSION_JSON=$(wget -q ${GIST}/raw/jumpbox-init-versions.json -O-)
function asset_version {
  ASSET_NAME=$1
  echo $VERSION_JSON | jq -r ".$ASSET_NAME"
}

function github_asset {
    REPO=$1
    EXPRESSION="${2:-linux}"
    TAG="${3:-latest}"
    curl -s https://api.github.com/repos/$REPO/releases/$TAG | jq -r ".assets[] | select(.name|test(\"$EXPRESSION\"))|.browser_download_url"
}
set -e

# Get updated url at https://github.com/cloudfoundry/bosh-cli/releases/latest
URL="$(github_asset cloudfoundry/bosh-cli linux-amd64)"
log Downloading: bosh from $URL
wget -q $URL -O $PROJ_DIR/bin/bosh
chmod a+x $PROJ_DIR/bin/bosh

# Get updated url at https://www.terraform.io/downloads.html
URL="https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip"
#URL="https://releases.hashicorp.com/terraform/0.12.19/terraform_0.12.19_linux_amd64.zip"
log Downloading: terraform from $URL
wget -q $URL -O /tmp/terraform.zip
gunzip -S .zip /tmp/terraform.zip
mv /tmp/terraform $PROJ_DIR/bin/terraform
chmod a+x $PROJ_DIR/bin/terraform

# Get updated url at https://github.com/cloudfoundry/bosh-bootloader/releases/latest
URL="$(github_asset cloudfoundry/bosh-bootloader linux_x86-64)"
log Downloading: bbl from $URL
wget -q $URL -O $PROJ_DIR/bin/bbl
chmod a+x $PROJ_DIR/bin/bbl


# Get updated url at https://github.com/concourse/concourse/releases/latest
URL="$(github_asset concourse/concourse fly.\*linux-amd64.tgz\$)"
log Downloading: fly from $URL
wget -q $URL -O- | tar -C $PROJ_DIR/bin -zx fly
chmod a+x $PROJ_DIR/bin/fly

# Get updated url at https://github.com/pivotal-cf/om/releases/latest
URL="$(github_asset pivotal-cf/om om-linux.\*tar.gz\$)"
log Downloading: om from $URL
wget -q $URL -O- | tar -C $PROJ_DIR/bin -zx om
chmod a+x $PROJ_DIR/bin/om

# Get updated url at https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/latest
URL="$(github_asset cloudfoundry-incubator/bosh-backup-and-restore bbr-.\*-linux-amd64\$)"
log Downloading: bbr from $URL
wget -q $URL -O $PROJ_DIR/bin/bbr
chmod a+x $PROJ_DIR/bin/bbr

# Always updated version :D
# Get updated url at https://github.com/cloudfoundry/cli/releases/latest
VERSION=$(curl -s https://api.github.com/repos/cloudfoundry/cli/releases/latest  | jq -r '.tag_name' | sed s/^v// )
URL="https://packages.cloudfoundry.org/stable?release=linux64-binary&version=$VERSION&source=github-rel"
log Downloading: cf from $URL
wget -q $URL  -O- | tar -C $PROJ_DIR/bin -zx cf
chmod a+x $PROJ_DIR/bin/cf

# Get updated url at https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest
URL="$(github_asset cloudfoundry-incubator/credhub-cli credhub-linux-.\*.tgz\$)"
log Downloading: credhub from $URL
wget -q $URL -O- | tar -C $PROJ_DIR/bin -xz  ./credhub
chmod a+x $PROJ_DIR/bin/credhub


# Always updated version :D
# Get updated url at https://storage.googleapis.com/kubernetes-release/release/stable.txt
URL="https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
log Downloading: kubectl from $URL
wget -q $URL -O $PROJ_DIR/bin/kubectl
chmod a+x $PROJ_DIR/bin/kubectl

# Get updated url at https://github.com/buildpacks/pack/releases/latest
URL="$(github_asset  buildpacks/pack pack-v.\*-linux.tgz\$)"
log Downloading: pack from $URL
wget -q $URL -O- | tar -C $PROJ_DIR/bin -zx pack
chmod a+x $PROJ_DIR/bin/pack

# Get updated url at https://download.docker.com/linux/static/stable/x86_64/
VERSION=$(curl -s https://api.github.com/repos/docker/docker-ce/releases/latest  | jq -r '.tag_name'   | sed s/^v//)
URL="https://download.docker.com/linux/static/stable/x86_64/docker-$VERSION.tgz"
log Downloading: docker from $URL
wget -q $URL -O- | tar -C /tmp -xz  docker/docker
mv /tmp/docker/docker $PROJ_DIR/bin/docker
chmod a+x $PROJ_DIR/bin/docker
rm -rf /tmp/docker

# Get updated url at https://github.com/docker/machine/releases/latest
URL="$(github_asset docker/machine $(uname -s)-$(uname -m))"
log Downloading: docker-machine from $URL
wget -q $URL  -O $PROJ_DIR/bin/docker-machine
chmod a+x $PROJ_DIR/bin/docker-machine


# Get updated url at "https://github.com/pivotal-cf/texplate/releases/latest
URL="$(github_asset  pivotal-cf/texplate linux_amd64)"
log Downloading: texplate from $URL
wget -q $URL -O $PROJ_DIR/bin/texplate
chmod a+x $PROJ_DIR/bin/texplate


# Get updated url at https://github.com/docker/compose/releases/latest
URL="$(github_asset docker/compose $(uname -s)-$(uname -m)\$)"
log Downloading: docker-compose from $URL
wget -q $URL -O $PROJ_DIR/bin/docker-compose
chmod a+x $PROJ_DIR/bin/docker-compose

# Get updated url at https://github.com/projectriff/riff/releases/latest
VERSION=$(asset_version riff)
URL="$(github_asset projectriff/cli  linux-amd64 tags/$VERSION)"
log Downloading: riff from $URL
wget -q $URL -O- | tar -C $PROJ_DIR/bin -xz ./riff
chmod a+x $PROJ_DIR/bin/riff

# Get updated url at https://github.com/cloudfoundry-incubator/uaa-cli/releases/latest
URL="$(github_asset cloudfoundry-incubator/uaa-cli linux-amd64)"
log Downloading: uaa from $URL
wget -q $URL -O $PROJ_DIR/bin/uaa
chmod a+x $PROJ_DIR/bin/uaa


# Get updated url at https://github.com/pivotal-cf/pivnet-cli/releases/latest
URL="$(github_asset pivotal-cf/pivnet-cli linux-amd64)"
log Downloading: pivnet
wget -q $URL -O $PROJ_DIR/bin/pivnet
chmod a+x $PROJ_DIR/bin/pivnet

# Get updated url at https://network.pivotal.io/products/pivotal-container-service/
VERSION=$(asset_version pivotal_container_service)
log PivNet Download: PKS client $VERSION
om download-product -t "$OM_PIVNET_TOKEN" -o /tmp -v "$VERSION"  -p pivotal-container-service --pivnet-file-glob='pks-linux-amd64-*'
mv /tmp/pks-linux-amd64-* $PROJ_DIR/bin/pks
chmod a+x $PROJ_DIR/bin/pks

# Get updated url at https://network.pivotal.io/products/pivotal-function-service/
VERSION="$(asset_version pivotal-function-service)"
log PivNet Download: PFS client $VERSION
om download-product -t "$OM_PIVNET_TOKEN" -o /tmp -v "$VERSION"  -p pivotal-function-service --pivnet-file-glob='pfs-cli-linux-amd64-*'
mv /tmp/pfs-cli-linux-amd64-* $PROJ_DIR/bin/pfs
chmod a+x $PROJ_DIR/bin/pfs

om download-product -t "$OM_PIVNET_TOKEN" -o /tmp -v "$VERSION" -p pivotal-function-service --pivnet-file-glob='duffle-linux-*'
mv /tmp/duffle-linux-* $PROJ_DIR/bin/duffle
chmod a+x $PROJ_DIR/bin/duffle


# Get updated url at https://github.com/projectriff/riff/releases/latest
VERSION=$(asset_version riff)
URL="$(github_asset projectriff/cli  linux-amd64 tags/$VERSION)"
log Downloading: riff from $URL $VERSION
wget -q $URL -O- | tar -C $PROJ_DIR/bin -xz ./riff
chmod a+x $PROJ_DIR/bin/riff

# Get updated url at https://github.com/sharkdp/bat/releases/latest
URL="$(github_asset  sharkdp/bat linux-gnu)"
log Downloading: bat from $URL
wget -q  $URL -O- | tar -C /tmp -xz bat-*-x86_64-unknown-linux-gnu/bat
mv /tmp/bat-*/bat $PROJ_DIR/bin/bat
chmod a+x  $PROJ_DIR/bin/bat


# Get updated url at https://github.com/direnv/direnv/releases/latest
URL="$(github_asset direnv/direnv linux-amd64)"
log Downloading: direnv from $URL
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
VERSION=$(asset_version p-scheduler)
log PivNet Download: Scheduler CF CLI Plugin $VERSION
om download-product -t "$OM_PIVNET_TOKEN" -o /tmp -v "$VERSION" -p p-scheduler --pivnet-file-glob='scheduler-for-pcf-cliplugin-linux64-binary-*'
cf install-plugin -f /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*

# Get updated url at https://network.pivotal.io/products/pcf-app-autoscaler
VERSION=$(asset_version pcf-app-autoscaler)
log PivNet Download: App Autoscaler CF CLI Plugin $VERSION
om download-product -t "$OM_PIVNET_TOKEN" -o /tmp -v "$VERSION"  -p pcf-app-autoscaler --pivnet-file-glob='autoscaler-for-pcf-cliplugin-linux64-binary-*'
cf install-plugin -f /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*

# Get updated url at https://network.pivotal.io/products/p-event-alerts
VERSION=$(asset_version p-event-alerts)
log PivNet Download: Event Alerts CF CLI Plugin $VERSION
om download-product -t "$OM_PIVNET_TOKEN" -o /tmp -v "$VERSION"  -p p-event-alerts --pivnet-file-glob='pcf-event-alerts-cli-plugin-linux64-binary-*'
cf install-plugin -f /tmp/pcf-event-alerts-cli-plugin-linux64-binary-*
rm /tmp/pcf-event-alerts-cli-plugin-linux64-binary-*


mkdir -p .vim/autoload
wget -q "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" -O $HOME/.vim/autoload/plug.vim
wget -q "${GIST}/raw/.vimrc" -O $HOME/.vimrc

log Setting TMUX
wget -q "${GIST}/raw/.tmux.conf" -O $HOME/.tmux.conf

log Put SSH keys
wget -q $GIST/raw/keys | while read key; do
  wget -qO - "$key" >> $HOME/.ssh/authorized_keys
done

cat <<EOF
========================================================================
SSH Config
========================================================================
To generate new keys and setup passwordless login run:
[ ! -f $HOME/.ssh/id_rsa ] && ssh-keygen  -q -t rsa -N "" && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
[ ! -f $HOME/.ssh/id_dsa ] && ssh-keygen  -q -t dsa -N "" && cat $HOME/.ssh/id_dsa.pub >> $HOME/.ssh/authorized_keys
EOF


log Done
