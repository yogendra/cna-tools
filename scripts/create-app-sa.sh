#!/bin/bash
set -eo pipefail

saname=${1?"Server Account Name Missing: create-app-sa.sh  <service-account> <namespace>"}
namespace=${2?"Namespace Missing: create-app-sa.sh <service-account> <namespace>"}

if ! kubectl get ns ${namespaces} &> /dev/null
then 
  kubectl create ns ${namespace}
fi

kubectl create sa ${saname} -n ${namespace}
kubectl create rolebinding ${saname}-admin --clusterrole=cluster-admin  --serviceaccount=${namespace}:${saname} -n ${namespace}
kubectl create clusterrolebinding ${namespace}-${saname}-ro --clusterrole=view --serviceaccount=${namespace}:${saname}   
