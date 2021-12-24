# CNA Tools Makefile
# Makefile uses a macro based build
# See: https://stackoverflow.com/questions/44488942/makefile-propagating-variables-to-dependent-targets

########################################################################################################################
# List of images here
# Add any new image in this variable. When you decommission, remove the entry from here
########################################################################################################################
images := ubuntu tanzu_jumpbox kubeshell webtop
########################################################################################################################


########################################################################################################################
# Build configuration - Mostly no need to change
########################################################################################################################
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
COMMIT := $(shell git rev-parse HEAD)

image_name := ""
docker_build_args := ""
docker_file = ""

.PHONY: all $(images)

all: $(images)

$(images): image_name = yogendra/$@
$(images): docker_file = ${ROOT_DIR}/yogendra/$@/Dockerfile
########################################################################################################################


########################################################################################################################
# OVERRIDES
# If the image has any special overrides, do them here. When you decommision an image, remove the correcponding entries 
# from here
########################################################################################################################

tanzu_jumpbox: image_name = yogendra/tanzu-jumpbox
tanzu_jumpbox:	docker_build_args = --secret id=jumpbox-secrets,src=${ROOT_DIR}/config/secrets.sh

########################################################################################################################


########################################################################################################################
# Main Build and Push Instruction
########################################################################################################################

$(images):
	DOCKER_BUILDKIT=1 docker buildx build \
		--platform linux/amd64 \
		--progress plain \
		-t docker.io/$(image_name):latest \
		-t docker.io/$(image_name):${COMMIT} \
		-t ghcr.io/$(image_name):latest  \
		-t ghcr.io/$(image_name):${COMMIT}  \
		-f $(docker_file) \
		$(docker_build_args) \
		${ROOT_DIR}
	docker push docker.io/$(image_name):latest
	docker push docker.io/$(image_name):${COMMIT}
	docker push ghcr.io/$(image_name):latest
	docker push ghcr.io/$(image_name):${COMMIT}

########################################################################################################################
