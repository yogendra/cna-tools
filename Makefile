# CNA Tools Makefile
# Makefile uses a macro based build
# See: https://stackoverflow.com/questions/44488942/makefile-propagating-variables-to-dependent-targets

########################################################################################################################
# List of images here
# Add any new image in this variable. When you decommission, remove the entry from here
########################################################################################################################
images := ubuntu cloud_jumpbox kubeshell webtop yb_gui_jumpbox ubuntu-minimal
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

cloud_jumpbox: image_name = yogendra/cloud-jumpbox
cloud_jumpbox: docker_build_args = --secret id=jumpbox-secrets,src=${ROOT_DIR}/config/secrets.sh
cloud_jumpbox: docker_context = ${ROOT_DIR}


yb_gui_jumpbox: image_name = yogendra/yb-gui-jumpbox
yb_gui_jumpbox: docker_context = yogendra/yb-gui-jumpbox
########################################################################################################################


########################################################################################################################
# Main Build and Push Instruction
########################################################################################################################

$(images):
	docker buildx build \
		--push \
		--platform linux/amd64,linux/arm64 \
		--progress plain \
		-t docker.io/$(image_name):latest \
		-t docker.io/$(image_name):${COMMIT} \
		-t ghcr.io/$(image_name):latest \
		-t ghcr.io/$(image_name):${COMMIT} \
		-f $(docker_file) \
		$(docker_build_args) \
		$(docker_context)

########################################################################################################################
