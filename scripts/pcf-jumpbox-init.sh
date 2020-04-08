#!/usr/bin/env bash
# Set these Environment variables
#  PROJ_DIR            : Project Directory. All tools will get install under PROJ_DIR/bin. (default: $HOME)
#  PIVNET_LEGACY_TOKEN : Pivotal Network Token (required) Its **NOT** ending with -r. It looks like DJHASLD7_HSDHA7 (default: none)
#  TIMEZONE            : Timezone of the host (default:Asua/Singapore)
#  GIT_REPO            : Git repository to use for supporting items (default: yogendra/pcf-tools)
#  PCF_TOOLS_DIR       : Location to put dotfiles (default: $HOME/code/pcf-tools)

# Run
# GIT_REPO=yogendra/dotfiles wget -qO- "https://raw.githubusercontent.com/${GIT_REPO}/master/scripts/jumpbox-init.sh?nocache"  | PIVNET_LEGACY_TOKEN=DJHASLD7_HSDHA7 bash
# Or to put binaries at your preferred location (example: /usr/local/bin), provide PROD_DIR
# GIT_REPO=yogendra/dotfiles wget -qO- "https://raw.githubusercontent.com/${GIT_REPO}/master/scripts/jumpbox-init.sh?nocache" | PIVNET_LEGACY_TOKEN=DJHASLD7_HSDHA7 PROJ_DIR=/usr/local bash


PROJ_DIR=${PROJ_DIR:-$HOME}
export PATH=${PATH}:${PROJ_DIR}/bin

PIVNET_LEGACY_TOKEN=${PIVNET_LEGACY_TOKEN}
[[ -z ${PIVNET_LEGACY_TOKEN} ]] && echo "PIVNET_LEGACY_TOKEN environment variable not set. See instructions at https://github.com/yogendra/dotfiles/blob/master/README-PCF-TOOLS.md" && exit 1
echo PROJ_DIR=${PROJ_DIR}


[[ -d ${PROJ_DIR}/bin ]]  || mkdir -p ${PROJ_DIR}/bin
GIT_REPO=${GIT_REPO:-yogendra/pcf-tools}
PCF_TOOLS_DIR=${PCF_TOOLS_DIR:-$HOME/code/pcf-tools}
TIMEZONE=${TIMEZONE:-Asia/Singapore}

sudo ln -fs /usr/share/zoneinfo/$TIMEZONE /etc/localtime

echo Install basic tools for the jumpbox
OS_TOOLS=(\
    apt-transport-https \
    build-essential \
    bzip2 \
    ca-certificates \
    coreutils \
    curl \
    dnsutils \
    file \
    git \
    gnupg2 \
    hping3 \
    httpie \
    iperf \
    iputils-ping \
    iputils-tracepath \
    jq \
    less \
    lsb-release \
    man \
    mosh \
    mtr \
    netcat \
    nmap \
    python2.7-minimal \
    python-pip \
    rclone \
    screen \
    shellcheck \
    software-properties-common \
    tcpdump \
    tmate \
    tmux \
    traceroute \
    unzip \
    vim \
    wamerican \
    wget \
    whois \
    )
sudo apt update && sudo apt install -qqy "${OS_TOOLS[@]}"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Docker 
wget -qO- "https://raw.githubusercontent.com/${GIT_REPO}/master/scripts/dotfiles-init.sh?$RANDOM"| bash
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# CF cli
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | sudo apt-key add -
echo "deb https://packages.cloudfoundry.org/debian stable main" | sudo tee /etc/apt/sources.list.d/cloudfoundry-cli.list

#Kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# GCP SDK
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

#Acure cli
curl -sL https://packages.microsoft.com/keys/microsoft.asc | 
    gpg --dearmor | 
    sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
AZ_REPO=$(lsb_release -cs) 
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | 
    sudo tee /etc/apt/sources.list.d/azure-cli.list


# Other tools
OS_TOOLS=(\
    azure-cli \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    kubectl \
    google-cloud-sdk
    )
sudo apt update && sudo apt install -qqy "${OS_TOOLS[@]}"


asset_json=$(cat ${PCF_TOOLS_DIR}/config/assets.json)
function asset_version {
  name=$1
  echo ${asset_json} | jq -r ".[\"$name\"].version"
}
function asset_url {
  name=$1
  echo ${asset_json} | jq -r ".[\"$name\"].url"
}

set -e

# Get updated url at https://github.com/cloudfoundry/bosh-cli/releases/latest
URL="$(asset_url bosh)"
echo Downloading: bosh from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/bosh
chmod a+x ${PROJ_DIR}/bin/bosh

# Get updated url at https://www.terraform.io/downloads.html
URL="$(asset_url terraform)"
echo Downloading: terraform from ${URL}
wget -q ${URL} -O /tmp/terraform.zip
gunzip -S .zip /tmp/terraform.zip
mv /tmp/terraform ${PROJ_DIR}/bin/terraform
chmod a+x ${PROJ_DIR}/bin/terraform

# Get updated url at https://github.com/cloudfoundry/bosh-bootloader/releases/latest
URL="$(asset_url bbl)"
echo Downloading: bbl from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/bbl
chmod a+x ${PROJ_DIR}/bin/bbl


# Get updated url at https://github.com/concourse/concourse/releases/latest
URL="$(asset_url fly)"
echo Downloading: fly from ${URL}
wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -zx fly
chmod a+x ${PROJ_DIR}/bin/fly

# Get updated url at https://github.com/pivotal-cf/om/releases/latest
URL="$(asset_url om)"
echo Downloading: om from ${URL}
wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -zx om
chmod a+x ${PROJ_DIR}/bin/om

# Get updated url at https://github.com/cloudfoundry-incubator/bosh-backup-and-restore/releases/latest
URL="$(asset_url bbr)"
echo Downloading: bbr from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/bbr
chmod a+x ${PROJ_DIR}/bin/bbr

# Always updated version :D
# Get updated url at https://github.com/cloudfoundry/cli/releases/latest
URL="$(asset_url cf)"
echo Downloading: cf from ${URL}
wget -q ${URL}  -O- | tar -C ${PROJ_DIR}/bin -zx cf
chmod a+x ${PROJ_DIR}/bin/cf

# Get updated url at https://github.com/cloudfoundry-incubator/credhub-cli/releases/latest
URL="$(asset_url credhub)"
echo Downloading: credhub from ${URL}
wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -xz  ./credhub
chmod a+x ${PROJ_DIR}/bin/credhub


# Always updated version :D
# Get updated url at https://storage.googleapis.com/kubernetes-release/release/stable.txt
URL="$(asset_url kubectl)"
echo Downloading: kubectl from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/kubectl
chmod a+x ${PROJ_DIR}/bin/kubectl

# Get updated url at https://github.com/buildpacks/pack/releases/latest
URL="$(asset_url pack)"
echo Downloading: pack from ${URL}
wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -zx pack
chmod a+x ${PROJ_DIR}/bin/pack


# Get updated url at "https://github.com/pivotal-cf/texplate/releases/latest
URL="$(asset_url texplate)"
echo Downloading: texplate from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/texplate
chmod a+x ${PROJ_DIR}/bin/texplate

# Get updated url at https://download.docker.com/linux/static/stable/x86_64/
URL="$(asset_url docker)"
echo Downloading: docker from ${URL}
wget -q ${URL} -O- | tar -C /tmp -xz  docker/docker
mv /tmp/docker/docker ${PROJ_DIR}/bin/docker
chmod a+x ${PROJ_DIR}/bin/docker
rm -rf /tmp/docker

# Get updated url at https://github.com/docker/machine/releases/latest
URL="$(asset_url docker-machine)"
echo Downloading: docker-machine from ${URL}
wget -q ${URL}  -O ${PROJ_DIR}/bin/docker-machine
chmod a+x ${PROJ_DIR}/bin/docker-machine

# Get updated url at https://github.com/docker/compose/releases/latest
URL="$(asset_url docker-compose)"
echo Downloading: docker-compose from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/docker-compose
chmod a+x ${PROJ_DIR}/bin/docker-compose

# Get updated url at https://github.com/projectriff/cli/releases/latest
URL="$(asset_url riff)"
echo Downloading: riff from ${URL}
wget -q ${URL} -O- | tar -C ${PROJ_DIR}/bin -xz ./riff
chmod a+x ${PROJ_DIR}/bin/riff

# Get updated url at https://github.com/cloudfoundry-incubator/uaa-cli/releases/latest
URL="$(asset_url uaa)"
echo Downloading: uaa from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/uaa
chmod a+x ${PROJ_DIR}/bin/uaa


# Get updated url at https://github.com/pivotal-cf/pivnet-cli/releases/latest
URL="$(asset_url pivnet)"
echo Downloading: pivnet from ${URL}
wget -q ${URL} -O ${PROJ_DIR}/bin/pivnet
chmod a+x ${PROJ_DIR}/bin/pivnet

# Get updated url at https://network.pivotal.io/products/pivotal-container-service/
VERSION=$(asset_version pivotal-container-service)
echo PivNet Download: PKS client ${VERSION}
om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p pivotal-container-service --pivnet-file-glob='pks-linux-amd64-*'
mv /tmp/pks-linux-amd64-* ${PROJ_DIR}/bin/pks
chmod a+x ${PROJ_DIR}/bin/pks

# Get updated url at https://network.pivotal.io/products/pivotal-function-service/
VERSION="$(asset_version pivotal-function-service)"
echo PivNet Download: PFS client ${VERSION}
om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p pivotal-function-service --pivnet-file-glob='pfs-cli-linux-amd64-*'
mv /tmp/pfs-cli-linux-amd64-* ${PROJ_DIR}/bin/pfs
chmod a+x ${PROJ_DIR}/bin/pfs

om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}" -p pivotal-function-service --pivnet-file-glob='duffle-linux-*'
mv /tmp/duffle-linux-* ${PROJ_DIR}/bin/duffle
chmod a+x ${PROJ_DIR}/bin/duffle

# Download build service client
VERSION="$(asset_version build-service)"
echo PivNet Download: Pivotal Build Service client ${VERSION}
om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p build-service --pivnet-file-glob="pb-${VERSION}-linux"
mv /tmp/pb-${VERSION}-linux ${PROJ_DIR}/bin/pb
chmod a+x ${PROJ_DIR}/bin/pb

om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p build-service --pivnet-file-glob="duffle-${VERSION}-linux"
mv /tmp/duffle-${VERSION}-linux ${PROJ_DIR}/bin/pb-duffle
chmod a+x ${PROJ_DIR}/bin/pb-duffle

# Get updated url at https://github.com/sharkdp/bat/releases/latest
VERSION="$(asset_version bat)"
URL="$(asset_url bat)"
echo Downloading: bat from ${URL}
wget -q  ${URL} -O- | tar -C /tmp -xz bat-${VERSION}-x86_64-unknown-linux-gnu/bat
mv /tmp/bat-${VERSION}-x86_64-unknown-linux-gnu/bat ${PROJ_DIR}/bin/bat
chmod a+x  ${PROJ_DIR}/bin/bat
rm -rf /tmp/bat-${VERSION}-x86_64-unknown-linux-gnu


# Get updated url at https://github.com/direnv/direnv/releases/latest
URL="$(github_url direnv/direnv)"
echo Downloading: direnv from ${URL}
wget -q  ${URL} -O ${PROJ_DIR}/bin/direnv
chmod a+x ${PROJ_DIR}/bin/direnv

# Get updated url at https://network.pivotal.io/products/p-scheduler
VERSION=$(asset_version p-scheduler)
echo PivNet Download: Scheduler CF CLI Plugin ${VERSION}
om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}" -p p-scheduler --pivnet-file-glob=scheduler-for-pcf-cliplugin-linux64-binary-\*
cf install-plugin -f /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/scheduler-for-pcf-cliplugin-linux64-binary-*

# Get updated url at https://network.pivotal.io/products/pcf-app-autoscaler
VERSION=$(asset_version pcf-app-autoscaler)
echo PivNet Download: App Autoscaler CF CLI Plugin ${VERSION}
om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p pcf-app-autoscaler --pivnet-file-glob=autoscaler-for-pcf-cliplugin-linux64-binary-\*
cf install-plugin -f /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*
rm /tmp/autoscaler-for-pcf-cliplugin-linux64-binary-*

# Get updated url at https://network.pivotal.io/products/p-event-alerts
VERSION=$(asset_version p-event-alerts)
echo PivNet Download: Event Alerts CF CLI Plugin ${VERSION}
om download-product -t "${PIVNET_LEGACY_TOKEN}" -o /tmp -v "${VERSION}"  -p p-event-alerts --pivnet-file-glob=pcf-event-alerts-cli-plugin-linux64-binary-\*
cf install-plugin -f /tmp/pcf-event-alerts-cli-plugin-linux64-binary-*
rm /tmp/pcf-event-alerts-cli-plugin-linux64-binary-*

echo Installing Keybase cli
wget -q https://prerelease.keybase.io/keybase_amd64.deb -O /tmp/keybase_amd64.deb 
sudo apt install -qqy /tmp/keybase_amd64.deb
rm /tmp/keybase_amd64.deb 
run_keybase

echo Install google-cloud-sdk
# Add the Cloud SDK distribution URI as a package source
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud Platform public key
wget -qO- https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

# Update the package list and install the Cloud SDK
sudo apt update
sudo apt -qqy install google-cloud-sdk


echo Install aws client
wget -q "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -O "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d $PROJ_DIR
rm -f /tmp/awscliv2.zip
sudo $PROJ_DIR/aws/install
rm -rf $PROJ_DIR/aws

echo Install  Azure client
wget -qO- https://aka.ms/InstallAzureCLIDeb | sudo bash


echo Created workspace directory
mkdir -p $PROJ_DIR/workspace/deployments
mkdir -p $PROJ_DIR/workspace/tiles

echo Setting shell: bash
echo "export PATH=$PCF_TOOLS_DIR/scripts:$PATH" >> ~/.bashrc


echo <<EOF
Create your SSH keys
===============================================================================
[[ ! -f ${HOME}/.ssh/id_rsa ]] && \
  ssh-keygen  -q -t rsa -N "" -f ${HOME}/.ssh/id_rsa && \
  cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys

[[ ! -f ${HOME}/.ssh/id_dsa ]] && \
  ssh-keygen  -q -t dsa -N "" -f ${HOME}/.ssh/id_dsa && \
  cat ${HOME}/.ssh/id_dsa.pub  >> ${HOME}/.ssh/authorized_keys

EOF

echo Done
