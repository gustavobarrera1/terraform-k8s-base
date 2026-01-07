resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace_vault
  }
}

resource "null_resource" "wait_for_cnpg_secret_data" {

  provisioner "local-exec" {
    command = <<-EOT
      SECRET_NAME="multidatabase-cluster-app"
      NAMESPACE="multidatabase"
      KEY_NAME="fqdn-uri"

      echo "Esperando a que el secreto $SECRET_NAME/$KEY_NAME tenga un valor válido..."

      for i in {1..60}; do
        VALUE=$(kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o jsonpath="{.data.$KEY_NAME}" 2>/dev/null || true)

        if [ ! -z "$VALUE" ]; then
          echo "Valor encontrado en el secreto."
          exit 0
        fi

        echo "Aún no disponible, esperando..."
        sleep 5
      done

      echo "ERROR: El secreto nunca tuvo datos."
      exit 1
    EOT
  }
}

data "kubernetes_resource" "cnpg_vault_user_secret" {
  api_version = "v1"
  kind        = "Secret"

  metadata {
    name      = "multidatabase-cluster-app"
    namespace = "multidatabase"
  }

  depends_on = [
    null_resource.wait_for_cnpg_secret_data
  ]
}

resource "kubernetes_secret" "vault_config_secret" {
  metadata {
    name      = var.secret_name
    namespace = var.namespace_vault
  }

  type = "Opaque"

  data = {
    "vault-postgresql.hcl" = local.vault_config_hcl_content
  }

  depends_on = [data.kubernetes_resource.cnpg_vault_user_secret]
}


resource "helm_release" "vault" {
  name       = var.name_vault
  repository = var.repository_vault
  chart      = var.chart_vault
  namespace  = var.namespace_vault

  values = [
    file(var.values_file_path_vault)
  ]
  set = [
    {
      name  = "server.volumes[0].name"
      value = "userconfig-vault-postgresql-backend-config-fromfile"
    },
    {
      name  = "server.volumes[0].secret.defaultMode"
      value = 420
    },

    {
      name  = "server.volumes[0].secret.secretName"
      value = var.secret_name
    },
  ]

  depends_on = [
    kubernetes_secret.vault_config_secret
  ]

}
