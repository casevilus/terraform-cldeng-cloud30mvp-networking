output "env" {
  value       = lookup(local.tags, "env", local.workspace_name)
  description = "env tag applied to Azure resources"
}

output "tags" {
  value       = local.tags
  description = "Tags applied to Azure resources"
}

output "subscription" {
  value       = data.azurerm_subscription.current.display_name
  description = "The subscription display name"
}

output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "The subscription GUID"
}

output "tenant_id" {
  value       = data.azurerm_subscription.current.tenant_id
  description = "The subscription tenant ID"
}

output "location" {
  value       = module.resource_group.location
  description = "The resource group location"
}

output "resource_group_name" {
  value       = module.resource_group.name
  description = "The resource group name"
}

output "subnet_addrs" {
  value = module.subnet_addrs
}

output "vnet_name" {
  value = local.vnet_name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}


output "vnet_address_space" {
  value       = module.subnet_addrs.base_cidr_block
  description = "Address space of Virtual Network"
}