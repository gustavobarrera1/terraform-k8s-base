module "cluster" {
  source = "./modules/cluster"
}

module "cnpg" {
  source                = "./modules/cnpg"
  values_file_path_cnpg = var.cnpg_values_file

  depends_on = [module.cluster]
}

module "vault" {
  source                 = "./modules/vault"
  values_file_path_vault = var.vault_values_file

  depends_on = [module.cnpg]
}

module "eso" {
  source = "./modules/eso"

  depends_on = [module.vault]
}