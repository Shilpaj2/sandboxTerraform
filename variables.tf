variable "rg" {
  description = "rg name"
  default     = "test-shi"
}
variable "location" {
  default = "eastus"
}
variable "tag" {
  default = "sandboxX"
}
/*
variable "vnetname" {
  default = "sandboxX-vnet"
}
variable "vnetAddress" {
  default = ["10.52.8.0/22"]
}
variable "firewallsubnetname" {
  default = "AzureFirewallSubnet"
}
variable "firewallprefix" {
  default = ["10.52.8.0/26"]
}
variable "firewallpip" {
  default = "sandboxX-FirewallPIP"
}
variable "fwname" {
  default = "sandboxX-firewall"
}
variable "bastionprefix" {
  default = ["10.52.8.64/26"]
}
variable "subnet1prefix" {
  default = ["10.52.8.128/27"]
}
variable "subnet2prefix" {
  default = ["10.52.9.0/27"]
}
variable "routetable" {
  default = "rtable-sandboxX"
}

variable "lognalyticworkspace" {
  default = "sbx-ws"
}
variable "customownerrole" {
  default = "sbx-owner-role"
}

variable "eventhubnamespace" {
  default = "sbx-eventhub09090808s"
}
variable "audithub" {
  default = "sbx-audit"
}
variable "activityhub" {
  default = "sbx-activity"
}
variable "adhub" {
  default = "sbx-addit"
}
variable "auditSASevent" {
  default = "sendtoauditlogsbxX"
}
variable "activitySASevent" {
  default = "sendtoactivitylogsbxX"
}
variable "adSASevent" {
  default = "sendtoadlogsbxX"
}
variable "auditexportrule" {
  default = "sbX-exportRule"
}
variable "logstorageaccountaname" {
  default = "sandbox0xlogs00x"
}

####policy variables
variable "builtin_policies_foundations" {
  type = list
  description = "List of built-in policy definitions (display names) for the foundations policyset"
  default = [
    "Azure Virtual Desktop hostpools should disable public network access",
    "Azure Databricks Workspaces should disable public network access",
    "Public network access should be disabled for Container registries",
    "Function app slots should disable public network access",
    "Azure Event Grid topics should disable public network access",
    "App Service apps should disable public network access",
    "Public network access on Azure SQL Database should be disabled",
    "Application Insights components should block log ingestion and querying from public networks",
    "Public network access on Azure Data Factory should be disabled",
    "Public network access on Azure IoT Hub should be disabled",
    "Azure Synapse workspaces should disable public network access",
    "App Configuration should disable public network access",
    "Azure Key Vault should disable public network access",
    "Azure Machine Learning Workspaces should disable public network access",
    //"Public network access on Azure Data Explorer should be disabled",
    "Azure Cache for Redis should disable public network access",
    "Azure Cosmos DB should disable public network access",
    "Azure Virtual Desktop workspaces should disable public network access",
    "Automation accounts should disable public network access",
    "Azure Media Services accounts should disable public network access",
    "Function apps should disable public network access",
    "Azure SQL Managed Instances should disable public network access",
    "Azure Virtual Desktop hostpools should disable public network access only on session hosts",
    "Public network access should be disabled for PostgreSQL servers",
    "IoT Hub device provisioning service instances should disable public network access",
    "Azure Event Grid domains should disable public network access"
  ]
}
###policy variable with disabled parameter
variable "disabled_policies_foundations" {
  type = list
  description = "List of built-in policy definitions for the foundations policyset"
  default = [
    "Configure Data Factories to disable public network access",
    "Configure Azure Virtual Desktop workspaces to disable public network access",
    "Configure Function apps to disable public network access",
    "Service Bus Namespaces should disable public network access",
    "Configure App Service app slots to disable public network access",
    //"Configure Batch accounts to disable public network access",
    "Modify - Configure Azure File Sync to disable public network access",
    "Modify - Configure Azure IoT Hubs to disable public network access",
    "Configure App Service apps to disable public network access",
    "Azure SignalR Service should disable public network access",
    "Configure Azure Automation accounts to disable public network access",
    "Configure Azure SQL Server to disable public network access",
    "Public network access should be disabled for PostgreSQL flexible servers",
    "Public network access should be disabled for Batch accounts"
  ]
}
*/
