# Cloud Native Architecture - Tools

This is a repo for frequently used CNA tools. I try to maintain a set of script and corresponding docker container images for this tools.

## Build Status

- [![Kubeshell](https://github.com/yogendra/cna-tools/actions/workflows/kubeshell.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/kubeshell.yml)
- [![Tanzu Jumpbox](https://github.com/yogendra/cna-tools/actions/workflows/tanzu-jumpbox.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/tanzu-jumpbox.yml)
- [![Ubuntu](https://github.com/yogendra/cna-tools/actions/workflows/ubuntu.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/ubuntu.yml)
- [![Webtop](https://github.com/yogendra/cna-tools/actions/workflows/webtop.yml/badge.svg)](https://github.com/yogendra/cna-tools/actions/workflows/webtop.yml)


## Introduction

This gist has scripts to quickly setup a jumpbox.

- Downloads tools (cf, om, bbl, etc)
- Add direnv support
- Add PCF extensions
- Setup SSH keys for login from my devices
- **Adds my SSH public keys to `authorized_keys`**
- Downloads tile/stemcell packages from pivnet
- Build a jumpbox container image

## Update assets version/urls

- Update `scripts/generate-asset.sh`
- Run `scripts/generate-versions.sh > config/assets.json`
- Commit changes and push repo
- Turn on debugging by setting `_DEBUG` environment variable

## Build Docker Image

1. Create a file named `secrets.sh` in the project directory, with following content:

   ```bash
   export PIVNET_LEGACY_TOKEN=<CHANGE_ME>
   export GITHUB_TOKEN="<CHANGE_ME>"
   export GITHUB_REPO="<CHANGE_ME>"
   export TIMEZONE=<CHANGE_ME>
   ```

   - Replace `<CHANGE_ME>` with proper values.
   - `PIVNET_LEGACY_TOKEN` is token form [Pivnet Profile Page][pivnet-profile]. This is **required**
   - `GITHUB_TOKEN` is used for accessing github. This is useful if you hit API access limits.
   - `GITHUB_REPO` is the repository on github that you want to use for init scripts
   - `TIMEZONE` is the timezone you want to set in the destination image

   **NOTE**: `GITHUB_OPTIONS` is optional and should be used if you run into API limit restrictions.

1. Build with make

   ```bash
    make tanzujumpbox
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
