resource "kubernetes_namespace" "external-secrets" {
  metadata {
    name = "external-secrets"
  }
}

resource "helm_release" "external_secrets" {
  name       = var.name_eso
  repository = var.repository_eso
  chart      = var.chart_eso
  namespace  = var.namespace_eso

  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]

  depends_on = [
    kubernetes_namespace.external-secrets
  ]
}