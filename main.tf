locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

# resource "kubernetes_namespace" "istio-system" {
#   metadata {
#     # annotations = {
#     #   name = "istio-system"
#     # }

#     # labels = {
#     #   mylabel = "istio-system"
#     # }

#     name = "istio-system"
#   }
# }

resource "helm_release" "istio-base" {
  repository       = local.istio_charts_url
  chart            = "istio/base"
  name             = "istio-base"
  namespace        = "istio-system"
  version          = var.istio_version
  create_namespace = true
  depends_on       = [kubernetes_namespace.istio-system]

  # set {
  #   name  = "cni.enabled"
  #   value = "true"
  # }
}

data "http" "manifestfile" {
  url = "https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/experimental-install.yaml"
}

resource "kubectl_manifest" "kubernetes_gateway_API_crd" {
  yaml_body = data.manifestfile.body
}


# resource "helm_release" "istiod" {
#   repository       = local.istio_charts_url
#   chart            = "istiod"
#   name             = "istiod"
#   namespace        = "istio-system"
#   create_namespace = false
#   version          = var.istio_version
#   depends_on       = [helm_release.istio-base, kubernetes_namespace.istio-system]
# }

# resource "helm_release" "istio-cni" {
#   repository = local.istio_charts_url
#   chart      = "gateway"
#   name       = "istio-cni"
#   namespace  = "istio-system"
#   version    = var.istio_version
#   depends_on = [helm_release.istiod]
# }

# resource "kubernetes_namespace" "istio-ingress" {
#   metadata {
#     labels = {
#       istio-injection = "enabled"
#     }

#     name = "istio-ingress"
#   }
# }


# resource "kubernetes_namespace" "istio-egress" {
#   metadata {
#     labels = {
#       istio-injection = "enabled"
#     }

#     name = "istio-egress"
#   }
# }

# resource "helm_release" "istio-ingress" {
#   repository       = local.istio_charts_url
#   chart            = "gateway"
#   name             = "istio-ingress"
#   namespace        = "istio-ingress"
#   create_namespace = false
#   version          = var.istio_version
#   depends_on       = [helm_release.istiod, kubernetes_namespace.istio-ingress]
# }

# resource "helm_release" "istio-egress" {
#   repository       = local.istio_charts_url
#   chart            = "gateway"
#   name             = "istio-egress"
#   namespace        = "istio-egress"
#   create_namespace = false
#   version          = var.istio_version
#   depends_on       = [helm_release.istiod, kubernetes_namespace.istio-egress]
# }