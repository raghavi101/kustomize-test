# About
This repository is a part of [GITOPSRVCE-119](https://issues.redhat.com/browse/GITOPSRVCE-119). It addresses the following question : 

````
Is it possible to create a Git repository which contains a large number of Kubernetes resources?
How many is large? Thousands? Tens of thousands? How large can it go before Argo CD refuses to handle it (or crashes).
````
## Steps
1. Clone this repository 
```
git clone https://github.com/raghavi101/kustomize-test.git
```
2. Aquire a cluster (minikube/oc etc).

4. At the root of the cloned repository run the shell script 
#### NOTE :  'argocd' namespace will be recreated afresh. Running deployments will be disgarded.
 ```
 ./script.sh
```
