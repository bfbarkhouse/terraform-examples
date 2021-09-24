policy "azure-appservice-prefix" {
  source            = "./azure-appservice-prefix.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "azure-appserviceplan-prefix" {
  source            = "./azure-appserviceplan.sentinel"
  enforcement_level = "hard-mandatory"
}