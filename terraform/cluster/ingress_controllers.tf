locals {
    ingress_controllers = [for v in [{
        name = "internal-ingress"
        node = "cluster-master-3"
    }, {
        name = "external-ingress"
        node = "cluster-master-2"
    }]: v if var.ingresses.enable]
}

resource "helm_release" "ingresses" {
for_each = { for ingress in local.ingress_controllers : ingress.name => ingress }
    repository = "https://kubernetes.github.io/ingress-nginx"
    chart = "ingress-nginx"
    name = each.key

    namespace = kubernetes_namespace.namespaces["ingress-controllers"].metadata[0].name

    set {
      name = "controller.hostNetwork"
      value = "true"
    }

    set {
      name = "controller.service.enabled"
      value = "false"
    }

    set {
      name = "controller.hostPort.enabled"
      value = "true"
    }

    set {
        name = "controller.nodeSelector.kubernetes\\.io/hostname"
        value = each.value.node
    }

    set {
        name = "controller.ingressClassResource.name"
        value = each.key
    }
}
