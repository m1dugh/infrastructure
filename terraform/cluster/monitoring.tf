resource "helm_release" "prometheus_stack" {
    count = var.monitoring.enable ? 1 : 0

    name = "kube-prometheus-stack"

    repository = "https://prometheus-community.github.io/helm-charts"

    chart = "kube-prometheus-stack"

    namespace = kubernetes_namespace.namespaces["monitoring"].metadata[0].name

    values = [yamlencode({
        grafana = {
            ingress = {
                enabled = true
                ingressClassName = "internal-ingress"
                hosts = [
                    "grafana.local.midugh.fr"
                ]
                annotations = {
                    "cert-manager.io/issuer" = "midugh-cluster-issuer"
                }
                tls = [{
                    secretName = "grafana-tls"
                    hosts = [
                        "grafana.local.midugh.fr"
                    ]
                }]
            }
        }
    })]
}
