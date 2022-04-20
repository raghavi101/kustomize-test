#!/bin/sh

kubectl delete namespace argocd
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 

tput setaf 3; echo "Waiting for ArgoCD to start . . ." ; tput sgr0

Resources=("argocd-application-controller" "argocd-applicationset-controller" "argocd-dex-server" "argocd-notifications-controller" "argocd-redis" "argocd-repo-server" "argocd-server")
for resource in ${Resources[*]}; do
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=$resource -n argocd
done

tput setaf 2; echo "Creating application . . ." ; tput sgr0
sleep 10;
kubectl apply -n argocd -f https://raw.githubusercontent.com/raghavi101/kustomize-test/master/application.yaml

tput setaf 6; echo "Loading metrics . . ."; tput sgr0
sleep 200
tput setaf 6; echo "Error statements regarding metrics unavailability can be ignored"; tput sgr0
while true; do kubectl top pods -n argocd; tput setaf 6; date; tput sgr0; sleep 20; done;



