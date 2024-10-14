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

    values = [yamlencode({
        extraVolumes = [{
            name = "certs"
            configMap = {
                name = data.kubernetes_config_map.extension_apiserver_authentication.metadata[0].name
                items = [{
                    key = "requestheader-client-ca-file"
                    path = "requestheader-client-ca.crt"
                }]
            }
        }]
        extraVolumeMounts = [{
            name = "certs"
            mountPath = "/certs"
            readOnly = true
        }]
        args = [
        "--requestheader-client-ca-file=/certs/requestheader-client-ca.crt"
        ]
    })]
}
