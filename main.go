package main

import (
	"github.com/bitfield/script"
)

func main() {
	script.Exec("kubectl create namespace argocd").Stdout()
	script.Exec("kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/core-install.yaml").Stdout()
	// script.Exec("kubectl port-forward svc/argocd-server -n argocd 8080:443").Stdout()
	// script.Exec("kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo").Stdout()

}
