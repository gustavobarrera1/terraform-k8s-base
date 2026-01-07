
resource "kubernetes_namespace" "multidatabase" {
  metadata {
    name = var.namespace_db
  }
}

resource "kubernetes_secret" "vault_schema_sql" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace_db
  }

  type = "Opaque"

  data = {
    "init.sql" = local.vault_schema_sql
  }

  depends_on = [kubernetes_namespace.multidatabase, local.vault_schema_sql]
}


resource "helm_release" "cnpg_database" {
  name       = var.name_db
  repository = var.repository_db
  chart      = var.chart_db
  namespace  = var.namespace_db

  values = [
    file(var.values_file_path_cnpg)
  ]

  depends_on = [kubernetes_secret.vault_schema_sql, kubernetes_namespace.multidatabase]
}