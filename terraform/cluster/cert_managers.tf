resource "helm_release" "cert-manager" {
    chart = "cert-manager"
    repository = "https://charts.jetstack.io"

    name = "cert-manager"
    version = "v1.16.1"

    namespace = kubernetes_namespace.namespaces["cert-manager"].metadata[0].name

    set {
      name = "crds.enabled"
      value = "true"
    }

    set {
        name = "prometheus.servicemonitor.enabled"
        value = "true"
    }
}

resource "kubernetes_secret" "cloudflare_secret" {
    metadata {
      name = "midugh-cloudflare-secret"
      annotations = local.default_annotations
      namespace = kubernetes_namespace.namespaces["cert-manager"].metadata[0].name
    }

    data = {
        api-token = var.cloudflare.token
    }
    type = "Opaque"
}

resource "kubernetes_manifest" "midugh_cluster_issuer" {
    manifest = {
        "apiVersion" = "cert-manager.io/v1"
        "kind" = "ClusterIssuer"
        "metadata" = {
            "name" = "midugh-cluster-issuer"
        }
        "spec" = {
            "acme" = {
                "server" = "https://acme-v02.api.letsencrypt.org/directory"
                "email" = "contact@midugh.fr"
                "privateKeySecretRef" = {
                    "name": "midugh-letsencrypt-prod"
                }
                "solvers" = [{
                    "dns01" = {
                        "cloudflare" = {
                            "apiTokenSecretRef" = {
                                "name" = kubernetes_secret.cloudflare_secret.metadata[0].name
                                "key" = "api-token"
                            }
                        }
                    }
                }]
            }
        }
    }
}
