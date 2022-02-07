# CNA Tools Makefile
# Makefile uses a macro based build
# See: https://stackoverflow.com/questions/44488942/makefile-propagating-variables-to-dependent-targets

########################################################################################################################
# List of images here
# Add any new image in this variable. When you decommission, remove the entry from here
########################################################################################################################
images := ubuntu tanzu_jumpbox kubeshell webtop yb_gui_jumpbox
########################################################################################################################


########################################################################################################################
# Build configuration - Mostly no need to change
########################################################################################################################
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
COMMIT := $(shell git rev-parse HEAD)

image_name := 
docker_build_args := 
docker_file = 

.PHONY: all $(images) amd64 arm64 image

all: $(images)

$(images): image_name = yogendra/$@
$(images): docker_file = ${ROOT_DIR}/yogendra/$@/Dockerfile
$(images): docker_context = ${ROOT_DIR}/yogendra/$@

########################################################################################################################


########################################################################################################################
# OVERRIDES
# If the image has any special overrides, do them here. When you decommision an image, remove the correcponding entries 
# from here
########################################################################################################################

kubeshell: docker_context = ${ROOT_DIR}

tanzu_jumpbox: image_name = yogendra/tanzu-jumpbox
tanzu_jumpbox:	docker_build_args = --secret id=jumpbox-secrets,src=${ROOT_DIR}/config/secrets.sh

yb_gui_jumpbox: image_name = yogendra/yb-gui-jumpbox

########################################################################################################################


########################################################################################################################
# Main Build and Push Instruction
########################################################################################################################



$(images): 
	@echo "$(image_name): Make for AMD64"
	DOCKER_BUILDKIT=1 docker \
	buildx build \
	--platform linux/amd64 \
	--progress plain \
	-t docker.io/$(image_name):latest-amd64 \
	-t docker.io/$(image_name):${COMMIT}-amd64 \
	-t ghcr.io/$(image_name):latest-amd64 \
	-t ghcr.io/$(image_name):${COMMIT}-amd64 \
	-f $(docker_file) \
	$(docker_build_args) \
	$(docker_context)
	docker push docker.io/$(image_name):latest-amd64
	docker push docker.io/$(image_name):${COMMIT}-amd64
	docker push ghcr.io/$(image_name):latest-amd64
	docker push ghcr.io/$(image_name):${COMMIT}-amd64	
	@echo "$@: Make for ARM64"
	DOCKER_BUILDKIT=1 docker \
	buildx build \
	--platform linux/arm64 \
	--progress plain \
	-t docker.io/$(image_name):latest-arm64 \
	-t docker.io/$(image_name):${COMMIT}-arm64 \
	-t ghcr.io/$(image_name):latest-arm64 \
	-t ghcr.io/$(image_name):${COMMIT}-arm64 \
	-f $(docker_file) \
	$(docker_build_args) \
	$(docker_context)
	docker push docker.io/$(image_name):latest-arm64
	docker push docker.io/$(image_name):${COMMIT}-arm64
	docker push ghcr.io/$(image_name):latest-arm64
	docker push ghcr.io/$(image_name):${COMMIT}-arm64
	@echo "$@: Create manifest"	
	docker manifest create \
	docker.io/$(image_name):latest \
	--amend docker.io/$(image_name):latest-amd64 \
	--amend docker.io/$(image_name):latest-arm64
	docker manifest create \
	docker.io/$(image_name):${COMMIT} \
	--amend docker.io/$(image_name):${COMMIT}-amd64 \
	--amend docker.io/$(image_name):${COMMIT}-arm64
	docker manifest create \
	ghcr.io/$(image_name):latest \
	--amend ghcr.io/$(image_name):latest-amd64 \
	--amend ghcr.io/$(image_name):latest-arm64
	docker manifest create \
	ghcr.io/$(image_name):${COMMIT} \
	--amend ghcr.io/$(image_name):${COMMIT}-amd64 \
	--amend ghcr.io/$(image_name):${COMMIT}-arm64
 	docker manifest push docker.io/$(image_name):latest
	docker manifest push docker.io/$(image_name):${COMMIT}
	docker manifest push ghcr.io/$(image_name):latest
	docker manifest push ghcr.io/$(image_name):${COMMIT}


########################################################################################################################
