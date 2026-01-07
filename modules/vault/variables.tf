variable "namespace_vault" {
  default = "vault"
}

variable "secret_name" {
  default = "vault-postgresql-backend-config-fromfile"
}

variable "name_vault" {
  default = "vault"
}

variable "chart_vault" {
  default = "vault"
}

variable "repository_vault" {
  default = "https://helm.releases.hashicorp.com"
}

variable "values_file_path_vault" {
  type = string
}