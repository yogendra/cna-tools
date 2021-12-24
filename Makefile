.PHONY: all ubuntu tanzu_jumpbox kubeshell webtop

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))


all: ubuntu tanzu_jumpbox kubeshell webtop

ubuntu: 
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64  --progress plain -f ${ROOT_DIR}/yogendra/ubuntu/Dockerfile -t yogendra/ubuntu:latest -t ghcr.io/yogendra/ubuntu:latest  ${ROOT_DIR}
	- docker push yogendra/cna-tools:ubuntu
	- docker push ghcr.io/cna-tools:ubuntu


tanzu_jumpbox: 
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64 --progress plain --secret id=jumpbox-secrets,src=${ROOT_DIR}/config/secrets.sh -f ${ROOT_DIR}/yogendra/tanzu-jumpbox/Dockerfile -t yogendra/tanzu-jumpbox:latest -t ghcr.io/yogendra/tanzu-jumpbox:latest ${ROOT_DIR}
	- docker push yogendra/cna-tools:tanzu-jumpbox
	- docker push ghcr.io/yogendra/cna-tools:tanzu-jumpbox

kubeshell: 
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64  --progress plain -t yogendra/kubeshell -t ghcr.io/yogendra/kubeshell -f ${ROOT_DIR}/yogendra/kubeshell/Dockerfile ${ROOT_DIR}
	- docker push yogendra/cna-tools:kubeshell
	- docker push ghcr.io/yogendra/cna-tools:kubeshell

webtop:
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64  --progress plain -t yogendra/webtop -t ghcr.io/yogendra/webtop  -f ${ROOT_DIR}/yogendra/webtop/Dockerfile ${ROOT_DIR}
	- docker push yogendra/cna-tools:webtop
	- docker push ghcr.io/yogendra/cna-tools:webtop
