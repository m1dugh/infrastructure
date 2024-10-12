resource "helm_release" "prometheus_stack" {
    name = "kube-prometheus-stack"

    repository = "https://prometheus-community.github.io/helm-charts"

    chart = "kube-prometheus-stack"

    namespace = kubernetes_namespace.namespaces["monitoring"].metadata[0].name
}
