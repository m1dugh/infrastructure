# Terraform of the k8s cluster

## Architecture

### Config

The actual config is stored in `config` folder.

### Modules

Modules are declared in `modules/` folder.

## Applying

The config should be loaded in the environment with the following variables:
- `KUBE_CONFIG_PATH`, the path to the kubeconfig file.
- `KUBE_CTX`, the name of the context to use.

The state is stored directly into the cluster.
