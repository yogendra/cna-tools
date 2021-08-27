#!/bin/bash
set -eo pipefail

saname=${1?"Service Account name missing: generate-sa-kubeconfig.sh <service-account> <namespace>"}
namespace=${2?"Namespace missing: generate-sa-kubeconfig.sh <service-account> <namespace>"}
server=$(kubectl config  view --minify -o jsonpath="{.clusters[0].cluster.server}")

context=$(kubectl config  current-context)
cluster=$(kubectl config  view --minify -o jsonpath="{.clusters[0].name}")

secret_name=$(kubectl -n ${namespace} get sa ${saname} -o jsonpath='{.secrets[0].name}')
ca=$(kubectl config  view --minify --raw -o jsonpath="{.clusters[0].cluster['certificate-authority-data']}")
token=$(kubectl -n ${namespace}  get secret/${secret_name} -o go-template='{{ .data.token | base64decode }}')

cat <<EOF
apiVersion: v1
kind: Config
clusters:
- name: ${cluster}
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: ${saname}@${cluster}
  context:
    cluster: ${cluster}
    namespace: ${namespace}
    user: ${saname}
current-context: ${saname}@${cluster}
users:
- name: ${saname}
  user:
    token: ${token}
EOF
