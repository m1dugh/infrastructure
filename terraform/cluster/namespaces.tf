resource "kubernetes_namespace" "monitoring" {
    metadata {
        name = "monitoring"
        annotations = local.default_annotations
    }
}

resource "kubernetes_namespace" "ingress-controllers" {
    metadata {
      name = "ingress-controllers"
      annotations = local.default_annotations
    }
}
