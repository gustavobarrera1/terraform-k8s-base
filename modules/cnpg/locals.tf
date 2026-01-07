locals {
  vault_schema_sql = file("${path.root}/config-files/vault-schema.sql")
}

# locals {
#   vault_db_uri = base64decode(
#     data.kubernetes_resource.cnpg_vault_user_secret.object.data["fqdn-uri"]
#   )

#   vault_config_hcl_content = templatefile(
#     "${path.root}/config-files/vault-postgresql.hcl.tpl",
#     { connection_uri = local.vault_db_uri }
#   )
# }