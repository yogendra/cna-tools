# Cloud Native Architecture - Tools

This is a repo for frequently used CNA tools. I try to maintain a set of script and corresponding docker container images for this tools.

## Build Status

- [![Kubeshell](https://github.com/yogendra/cna-tools/actions/workflows/kubeshell.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/kubeshell.yml)
- [![Cloud Jumpbox](https://github.com/yogendra/cna-tools/actions/workflows/cloud-jumpbox.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/cloud-jumpbox.yml)
- [![Ubuntu](https://github.com/yogendra/cna-tools/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/ubuntu.yml)
- [![Webtop](https://github.com/yogendra/cna-tools/actions/workflows/webtop.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/webtop.yml)
- [![Webtop](https://github.com/yogendra/cna-tools/actions/workflows/ubuntu-minimal.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/ubuntu-minimal.yml)

## Local Build

On Mac, you need to create a builder

```bash
docker buildx create --use --name multiarch --node multiarch --driver-opt network=host --bootstrap
```

## Introduction

This repo has scripts to quickly setup a jumpbox.

- Downloads common tools
- Add direnv support
- Setup SSH keys for login from my devices
- **Adds my SSH public keys to `authorized_keys`**
- Downloads tile/stemcell packages from pivnet
- Build into container image

## Update assets version/urls

- Update `scripts/generate-asset.sh`
- Run `scripts/generate-versions.sh > config/assets.json`
- Commit changes and push repo
- Turn on debugging by setting `_DEBUG` environment variable

## Build Docker Image

1. Build with make

   ```bash
    make
   ```

## Add a new Docker Image

1. Create a directory for image.
   **Example**
   Image Name: `yogendra/myimage`
   Directory: `<Project Dir>/yogendra/myimage`

2. Create Dockerfile and Yaml (if needed), under the image directory. Example `<Project Dir>/yogendra/myimage/Dockerfile` and `<Project Dir>/yogendra/myimage/myimage.yaml`

3. Update Makefile

      a. Add image name to `image` variable on top

      b. Add any overrides in middle of the file. Instructions are in the Makefile

4. Add github action file under `<Project Dir>/.github/workflow`. Example: `<Project Dir>/.github/workflow/myimage.yml`. You can copy one of the existing ones to start with.

[pivnet-profile]: https://network.pivotal.io/users/dashboard/edit-profile
[build-jumpbox]: https://github.com/yogendra/pcf-tools/actions?query=workflow%3A%22Jumpbox+Docker+Build%22
[badge-jumpbox]: https://github.com/yogendra/pcf-tools/workflows/Jumpbox%20Docker%20Build/badge.svg
