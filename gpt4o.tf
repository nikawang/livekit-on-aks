module "openai" {
  source              = "Azure/openai/azurerm"
  version             = "0.1.5"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "East US 2"
  sku_name = "S0"
  account_name = "livekit-${random_id.str.hex}"

  public_network_access_enabled = true
  deployment = {
    "gpt-35-turbo" = {
      name          = "gpt-4o-realtime-preview"
      model_format  = "OpenAI"
      model_name    = "gpt-4o-realtime-preview"
      model_version = "2024-10-01"
      scale_type    = "GlobalStandard"
    },
  }

  depends_on = [ azurerm_resource_group.rg ]
}
# output "openai_model_endpoint" {
#   value = module.openai.account_name
# }

# output "openai_model_key" {
#   value = module.openai.openai_primary_key
#   sensitive = true
# }