locals {
  ingress_controllers = [for v in [{
    name  = "internal-ingress"
    http  = 31080
    https = 31443
    node  = "cluster-master-2"
    }, {
    name  = "external-ingress"
    http  = 30080
    https = 30443
    node  = "cluster-master-3"
  }] : v if var.ingresses.enable]
}

resource "helm_release" "ingresses" {
  for_each   = { for ingress in local.ingress_controllers : ingress.name => ingress }
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = each.key

  namespace = kubernetes_namespace.namespaces["ingress-controllers"].metadata[0].name

  upgrade_install = true

  values = [yamlencode({
    controller = {
      nodeSelector = {
        "kubernetes.io/hostname" = each.value.node
      }
      electionID = "${each.key}-leader"
      service = {
        type = "NodePort"
        nodePorts = {
          http  = each.value.http
          https = each.value.https
        }
      }
      ingressClassResource = {
        name            = each.key
        controllerValue = "k8s.io/${each.key}-nginx"
      }
      ingressClass = each.key
    }
  })]
}
