#!/bin/bash
set -eo pipefail

saname=${1?"Service Account name missing: generate-sa-kubeconfig.sh <service-account> <namespace>"}
namespace=${2?"Namespace missing: generate-sa-kubeconfig.sh <service-account> <namespace>"}

context=$(kubectl config  current-context)
cluster=$(kubectl config  view --flatten -o jsonpath="{.contexts[?(@.name == \"$context\")].context.cluster}")
name=$(kubectl -n ${namespace} get sa ${saname} -o jsonpath='{.secrets[0].name}')

ca=$(kubectl -n ${namespace} get secret/$name -o jsonpath='{.data.ca\.crt}')
token=$(kubectl -n ${namespace}  get secret/$name -o go-template='{{ .data.token | base64decode }}')
server=$(kubectl config  view --flatten --minify -o jsonpath="{.clusters[?(@.name == \"$cluster\")].cluster.server}")

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
