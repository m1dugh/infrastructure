resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = var.namespace
    annotations = var.default_annotations
  }
}

resource "helm_release" "operator" {
    name = "operator"
    chart = "operator"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    repository = "https://operator.min.io"

    version = "6.0.1"
}
