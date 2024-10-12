resource "kubernetes_namespace" "namespaces" {
    for_each = { for n in var.namespaces: n => n }
    metadata {
        name = each.key
        annotations = local.default_annotations
    }
}
