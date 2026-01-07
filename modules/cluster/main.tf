resource "kubernetes_namespace" "cnpg-system" {
  metadata {
    name = var.namespace_cnpg
  }
}

resource "helm_release" "cnpg_cluster" {
  name       = var.name_cnpg
  repository = var.repository_cnpg
  chart      = var.chart_cnpg
  namespace  = var.namespace_cnpg

  depends_on = [kubernetes_namespace.cnpg-system]
}
