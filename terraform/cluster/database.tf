resource "helm_release" "postgresql" {
  count     = var.database.enable ? 1 : 0
  version   = "16.0.3"
  name      = "postgresql"
  chart     = "oci://registry-1.docker.io/bitnamicharts/postgresql"
  namespace = kubernetes_namespace.namespaces["database"].metadata[0].name

  values = [yamlencode({
    global = {
      storageClass = local.storage_class_name
    }
  })]
}

resource "helm_release" "pgadmin" {
  count      = var.database.enable ? 1 : 0
  version    = "1.31.0"
  name       = "pgadmin"
  repository = "https://helm.runix.net"
  chart      = "pgadmin4"
  namespace  = kubernetes_namespace.namespaces["database"].metadata[0].name

  depends_on = [helm_release.postgresql[0]]

  values = [yamlencode({
    persistentVolume = {
        storageClass = local.storage_class_name
        size = "5Gi"
    }
    ingress = {
      enabled          = true
      ingressClassName = "internal-ingress"
      hosts = [{
        host = "db.local.midugh.fr"
        paths = [{
            path = "/"
            pathType = "Prefix"
        }]
      }]
      annotations = {
        "cert-manager.io/cluster-issuer" = "midugh-cluster-issuer"
      }
      tls = [{
        secretName = "pgadmin-tls"
        hosts = [
          "db.local.midugh.fr"
        ]
      }]
    }
  })]
}
