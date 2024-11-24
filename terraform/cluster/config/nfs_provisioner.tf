locals {
  storage_class_name = "nfs-provisioner"
}
resource "helm_release" "nfs_provisioner" {
  count           = var.nfs_provisioner.enable ? 1 : 0
  repository      = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart           = "nfs-subdir-external-provisioner"
  name            = "nfs-provisioner"
  namespace       = "default"
  upgrade_install = true
  values = [yamlencode({
    storageClass = {
      name            = local.storage_class_name
      provisionerName = "k8s-sigs.io/nfs-provisioner"
    }
    nfs = {
      server = "192.168.1.145"
      path   = "/shared"
    }
  })]
}
