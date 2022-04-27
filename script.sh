#!/usr/bin/env bash

set -e
if ! [ -x "$(command -v kubectl)" ]; then
  echo 'Error: kubectl is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

namespaceStatus=$(kubectl get ns argocd -o json | jq .status.phase -r)
if [ "$namespaceStatus" == "Active" ]
then
  kubectl delete namespace argocd 
  kubectl create namespace argocd
else
  kubectl create namespace argocd
fi
kubectl apply -n argocd -f manifests/argo.yaml 
kubectl apply -n kube-system -f manifests/components.yaml

tput setaf 3; echo "Waiting for ArgoCD to start . . ." ; tput sgr0

Resources=("argocd-application-controller" "argocd-applicationset-controller" "argocd-dex-server" "argocd-notifications-controller" "argocd-redis" "argocd-repo-server" "argocd-server")
for resource in ${Resources[*]}; do
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=$resource -n argocd
done

tput setaf 2; echo "Creating application . . ." ; tput sgr0

kubectl apply -n argocd -f ./application.yaml

tput setaf 6; echo "Loading metrics . . ."; tput sgr0
sleep 200
tput setaf 6; echo "Error statements regarding metrics unavailability can be ignored"; tput sgr0
set +e
while true; do kubectl top pods -n argocd; tput setaf 6; date; tput sgr0; sleep 20; done;



