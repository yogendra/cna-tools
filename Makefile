.PHONY: all
all: yogendra_ubuntu tanzujumpbox kubeshell

yogendra_ubuntu: 
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64  --progress plain -f yogendra_ubuntu.Dockerfile -t yogendra/ubuntu:latest  .
	@docker push yogendra/ubuntu:latest


tanzujumpbox: yogendra_ubuntu
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64 --progress plain --secret id=jumpbox-secrets,src=${PWD}/config/secrets.sh -f yogendra_tanzu-jumpbox.Dockerfile -t yogendra/tanzu-jumpbox:latest .
  @docker push yogendra/tanzu-jumpbox:latest

kubeshell: yogendra_ubuntu
	@DOKER_BUILDKIT=1 docker buildx build --platform linux/amd64  --progress plain -t yogendra/kubeshell -f yogendra_kubeshell.Dockerfile .
	- docker push yogendra/kubeshell 
