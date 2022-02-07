FROM yogendra/webtop

ARG TARGETPLATFORM

LABEL org.opencontainers.image.description Browser based GUI Jumpbox 
LABEL org.opencontainers.image.source  https://github.com/yogendra/cna-tools/blob/main/yogendra/webtop/Dockerfile
LABEL org.opencontainers.image.vendor Yogi Rampuria (@yogendra)
LABEL org.opencontainers.image.title  yogendra/webtop
LABEL org.opencontainers.image.source https://github.com/yogendra/cna-tools

ADD usr/share/applications/* /usr/share/applications
RUN set -e && \
  sudo apt-get update && \
  sudo apt-get install -qqy openjdk-17-jre-headless && \
  if [ "$TARGETPLATFORM" = "linux/arm64" ] ; then \
    curl -L https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.aarch64-nojdk.tar.gz -o dbeaver.tgz ; \
  elif [ "$TARGETPLATFORM" = "linux/amd64" ] ; then \
    curl -L https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64-nojdk.tar.gz -o dbeaver.tgz ; \
  fi && \
  sudo tar -xzf dbeaver.tgz -C /usr/share && \
  rm dbeaver.tgz 

  
