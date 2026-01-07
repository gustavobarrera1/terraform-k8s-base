storage "postgresql" {
  connection_url = "${connection_uri}?sslmode=disable"
  table = "vault_kv_store"
  ha_enabled = "true"
  ha_table = "vault_ha_locks"
}