# This script's purpose is to generate a hierarchical file structure as follows : 
# Each of these dir 1a, 1b, 1c, 1d, 1e, 1f, 1g, 1h, 1i, 1j contain a kustomization.yaml and a dep.yaml
# Each of these dir 2a . . . 2j contain 1a . . . 1j 
#                 layer5
#        /  /  /   / | \  \  \  \  \    
#       4a 4b 4c 4d 4e 4f 4g 4h 4i 4j
#        .  .  .  .  .  .  .  .  .  . 
#        .  .  .  .  .  .  .  .  .  . 
#        .  .  .  .  .  .  .  .  .  . 
#       1a-1j.......................1a-1j

import os

def create_yaml(path, resource):
    yaml = f"apiVersion: kustomize.config.k8s.io/v1beta1\nkind: Kustomization\nnamePrefix: {path.split('/')[-1].replace('layer', '')}-\n\nresources: \n" + resource
    open(f"{path}/kustomization.yaml", "w").write(yaml)

def burst(path: str, n: int):
    if n == 0:
 #       os.system(f"cp https://raw.githubusercontent.com/raghavi101/kustomize-test/master/manifests/dep.yaml {path}")
        create_yaml(path, "- https://raw.githubusercontent.com/raghavi101/kustomize-test/master/manifests/dep.yaml")
        return

    for j in "abcdefghij":
        os.makedirs(f"{path}/layer{n}{j}")
        burst(f"{path}/layer{n}{j}", n-1)

    create_yaml(path, "\n".join([f"- layer{n}{i}" for i in "abcdefghij"]))

os.mkdir("layer5")
burst("layer5", 4)
