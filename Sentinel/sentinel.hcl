module "tfplan-functions" {
  source = "./common-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
  source = "./common-functions/tfstate-functions.sentinel"
}

// policy "azure-appservice-prefix" {
//   source            = "./azure-appservice-prefix.sentinel"
//   enforcement_level = "hard-mandatory"
// }

// policy "azure-appserviceplan-prefix" {
//   source            = "./azure-appserviceplan-prefix.sentinel"
//   enforcement_level = "hard-mandatory"
// }

policy "dynamic-public-ip" {
  source            = "./dynamic-public-ip.sentinel"
  enforcement_level = "hard-mandatory"
}