resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = var.namespace
    annotations = var.default_annotations
  }
}
