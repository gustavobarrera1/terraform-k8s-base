variable "namespace_db" {
  default = "multidatabase"
}

variable "name_db" {
  default = "multidatabase"
}

variable "chart_db" {
  default = "cluster"
}

variable "repository_db" {
  default = "https://cloudnative-pg.github.io/charts"
}

variable "secret_name" {
  default = "vault-init-sql"
}

variable "values_file_path_cnpg" {
  type = string
}