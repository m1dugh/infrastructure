data "kubernetes_config_map" "extension_apiserver_authentication" {
    metadata {
      name = "extension-apiserver-authentication"
      namespace = "kube-system"
    }
}

resource "helm_release" "metrics_server" {
    count = var.metrics_server.enable ? 1 : 0
    name = "metrics-server"
    chart = "metrics-server"
    repository = "https://kubernetes-sigs.github.io/metrics-server/"

    namespace = "kube-system"
}
