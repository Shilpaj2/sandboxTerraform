/*
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}
output "event_hub_namespace_name" {
  value = azurerm_eventhub_namespace.eventhub_namespace.name
}
output "auditlog_event_hub_name" {
  value = azurerm_eventhub.audit_log.name
}
output "auditlog_SAS_Key_Name" {
  value = azurerm_eventhub_authorization_rule.audit_log_auth.name
}
output "auditlog_SAS_token" {
  value = nonsensitive(azurerm_eventhub_authorization_rule.audit_log_auth.primary_connection_string)
}
output "activitylog_event_hub_name" {
  value = azurerm_eventhub.activity_log.name
}
output "activitylog_SAS_Key_Name" {
  value = azurerm_eventhub_authorization_rule.activity_log_auth.name
}
output "activitylog_SAS_token" {
  value = nonsensitive(azurerm_eventhub_authorization_rule.activity_log_auth.primary_connection_string)
}

output "adlog_event_hub_name" {
  value = azurerm_eventhub.ad_log.name
}
output "adlog_SAS_Key_Name" {
  value = azurerm_eventhub_authorization_rule.ad_log_auth.name
}
output "adlog_SAS_token" {
  value = nonsensitive(azurerm_eventhub_authorization_rule.ad_log_auth.primary_connection_string)
}
output "log_storageaccount_key" {
  value = nonsensitive(azurerm_storage_account.log_storage.primary_access_key)
}
output "storage_account_name" {
  value = azurerm_storage_account.log_storage.name
}
*/
