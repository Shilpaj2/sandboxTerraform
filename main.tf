terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "37e6dd43-6638-42f2-b26f-19804b53367f"
  tenant_id       = "34bc2abb-5c12-4b3b-a6d2-2203b846de91"
  client_id       = "49c144c6-cf05-4d3b-abb7-17b27bed27ca"
  client_secret   = "ZZh8Q~iX6KiSpit.0zUqjk2ODD7gW2WfIb1F.bSy"
}
provider "azuread" {
  tenant_id       = "34bc2abb-5c12-4b3b-a6d2-2203b846de91"
  client_id       = "49c144c6-cf05-4d3b-abb7-17b27bed27ca"
  client_secret   = "ZZh8Q~iX6KiSpit.0zUqjk2ODD7gW2WfIb1F.bSy"
}

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rg
  location = var.location
  tags = {
    environment = var.tag
  }
}
/*
# Built-in Policy Definition ID (replace with actual built-in policy ID)
resource "azurerm_policy_set_definition" "example" {
  name = "foundations"
  policy_type  = "Custom"
  display_name = "Foundations"
  description  = "Contains built-in policies for Foundations"
  metadata = jsonencode({ category = "Custom", version = "1.0.0", source = "Terraform" })
  dynamic "policy_definition_reference" { #built-in policies without parameter_values
    for_each = data.azurerm_policy_definition.builtin_policies_foundations
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id = policy_definition_reference.value["display_name"]
      parameter_values = jsonencode({ "effect" : { value = "Deny"} })
    }
  }

  dynamic "policy_definition_reference" { #built-in policies with disabled parameters
    for_each = data.azurerm_policy_definition.disabled_policies_foundations
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id = policy_definition_reference.value["display_name"]
      parameter_values = jsonencode({ "effect" : { value = "Disabled"} })
    }
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    reference_id = "Allowed locations"
    parameter_values = jsonencode({ "listofAllowedLocations" : { value = ["usgovvirginia", "usgov", "usgovarizona","usgoviowa"]} })
  }
}

resource "azurerm_subscription_policy_assignment" "policy_assignment" {
  name = "example-policy-assignment"
  display_name = "Example Policy Assignment"
  subscription_id = "/subscriptions/37e6dd43-6638-42f2-b26f-19804b53367f"
  policy_definition_id = azurerm_policy_set_definition.example.id
  location = var.location
  non_compliance_message {
    content = "this is a test message."
  }
  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_policy_definition" "builtin_policies_foundations" {
  count = length(var.builtin_policies_foundations)
  display_name =  var.builtin_policies_foundations[count.index]
}

data "azurerm_policy_definition" "disabled_policies_foundations" {
  count = length(var.disabled_policies_foundations)
  display_name =  var.disabled_policies_foundations[count.index]
}
*/
# create Virtual network with app subnets
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetname
  address_space       = var.vnetAddress
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "subnet1" {
  name                 = "app-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet1prefix
}
resource "azurerm_subnet" "subnet2" {
  name                 = "app-2"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet2prefix
}

### Azure route table for firewall route and subnet association
/*
resource "azurerm_route_table" "rt" {
  name                = var.routetable
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "firewall-outbound"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration[0].private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "rtassociation1" {
  subnet_id      = azurerm_subnet.subnet1.id
  route_table_id = azurerm_route_table.rt.id
}

resource "azurerm_subnet_route_table_association" "rtassociation2" {
  subnet_id      = azurerm_subnet.subnet2.id
  route_table_id = azurerm_route_table.rt.id
}

### Azure Firewall

resource "azurerm_subnet" "subnet-firewall" {
  name                 = var.firewallsubnetname
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewallprefix
}

resource "azurerm_public_ip" "firewall-pip" {
  name                = var.firewallpip
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = var.fwname
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet-firewall.id
    public_ip_address_id = azurerm_public_ip.firewall-pip.id
  }
  firewall_policy_id = azurerm_firewall_policy.fw-policy.id
}

resource "azurerm_firewall_policy" "fw-policy" {
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

### azure bastion
resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.bastionprefix
}

resource "azurerm_public_ip" "bastionpip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "example" {
  name                = "bastionhost"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}
### Create Custom role
data "azurerm_resource_group" "rg" {
  name = azurerm_resource_group.rg.name
}
resource "azurerm_role_definition" "customrole" {
  name        = var.customownerrole
  scope       = data.azurerm_resource_group.rg.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions = ["*"]
    not_actions = [
      "Microsoft.ClassicNetwork/virtualNetworks/delete",
      "Microsoft.ClassicNetwork/virtualNetworks/write",
      "Microsoft.Authorization/*/Delete",
      "Microsoft.Authorization/*/Write",
      "Microsoft.Authorization/elevateAccess/Action",
      "Microsoft.Blueprint/blueprintAssignments/write",
      "Microsoft.Blueprint/blueprintAssignments/delete",
      "Microsoft.ClassicNetwork/virtualNetworks/write",
      "Microsoft.ClassicNetwork/virtualNetworks/delete",
      "Microsoft.Network/azurefirewalls/delete",
      "Microsoft.Network/virtualNetworks/subnets/write",
      "Microsoft.Network/virtualNetworks/subnets/delete",
      "Microsoft.Network/bastionHosts/delete",
      "Microsoft.Network/bastionHosts/write",
      "Microsoft.Insights/MonitoredObjects/Write",
      "Microsoft.Insights/MonitoredObjects/Delete",
      "Microsoft.Network/azurefirewalls/write",
      "Microsoft.Network/ddosProtectionPlans/ddosProtectionPlanProxies/delete",
      "Microsoft.Network/expressRouteCrossConnections/write",
      "Microsoft.Network/expressRouteCrossConnections/delete",
      "Microsoft.Network/publicIPAddresses/write",
      "Microsoft.Network/publicIPAddresses/delete",
      "Microsoft.Network/virtualWans/write",
      "Microsoft.Network/virtualWans/delete",
      "Microsoft.Network/vpnsites/write",
      "Microsoft.Network/vpnsites/delete",
      "Microsoft.Network/vpnGateways/write",
      "Microsoft.Network/vpnGateways/delete",
      "microsoft.network/vpnGateways/vpnConnections/write",
      "microsoft.network/vpnGateways/vpnConnections/delete",
      "Microsoft.Network/virtualNetworks/write",
      "Microsoft.Network/virtualNetworks/delete"
    ]
  }
  assignable_scopes = [
    azurerm_resource_group.rg.id # /subscriptions/00000000-0000-0000-0000-000000000000
  ]
}

resource "azuread_group" "aad-owner" {
  display_name     = "Sandbox Owners"
  security_enabled = true
  # members = [data.azurerm_client_config.current.object_id ]
}

resource "azurerm_role_assignment" "customrole-owner-assignment" {
  principal_id       = azuread_group.aad-owner.object_id
  scope              = azurerm_resource_group.rg.id
  role_definition_id = azurerm_role_definition.customrole.id
}

# Creates Log Anaylytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics_ws" {
  name                = var.lognalyticworkspace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

### Log storage account
resource "azurerm_storage_account" "log_storage" {
  name                     = var.logstorageaccountaname
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

##Event hub namespace
resource "azurerm_eventhub_namespace" "eventhub_namespace" {
  name                = var.eventhubnamespace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "audit_log" {
  name                = var.audithub
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "audit_log_auth" {
  name                = var.auditSASevent
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  eventhub_name       = azurerm_eventhub.audit_log.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub" "activity_log" {
  name                = var.activityhub
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "activity_log_auth" {
  name                = var.activitySASevent
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  eventhub_name       = azurerm_eventhub.activity_log.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub" "ad_log" {
  name                = var.adhub
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "ad_log_auth" {
  name                = var.adSASevent
  namespace_name      = azurerm_eventhub_namespace.eventhub_namespace.name
  eventhub_name       = azurerm_eventhub.ad_log.name
  resource_group_name = azurerm_resource_group.rg.name
  listen              = true
  send                = false
  manage              = false
}


### log analytics export rule
resource "azurerm_log_analytics_data_export_rule" "example" {
  name                    = "dataExport1"
  resource_group_name     = azurerm_resource_group.rg.name
  workspace_resource_id   = azurerm_log_analytics_workspace.log_analytics_ws.id
  destination_resource_id = azurerm_eventhub.audit_log.id
  depends_on = [ azurerm_eventhub_authorization_rule.audit_log_auth ]
  table_names             = ["Heartbeat","Usage","Alert","InsightsMetrics","Operation","AzureMetrics","AzureActivity","AzureDiagnostics"]
  enabled                 = true
}
*/
