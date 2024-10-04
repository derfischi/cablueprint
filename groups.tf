data "azuread_administrative_unit" "restricted_groups" {
  object_id = var.restricted_groups_adminunit_id
}

data "azuread_group" "breakglassgroup" {
  object_id = var.breakglass_group_id
}

resource "azuread_group" "blockedaccounts" {
  display_name     = "SEC-CA-Blocked Accounts"
  description      = "Explicitly blocked accounts"
  security_enabled = true
}

resource "azuread_group" "legacyauth" {
  display_name     = "SEC-CA-LegacyAuth Exception"
  description      = "Exception group to allow Legacy Authentication eg. for SMTP in Conditional Access"
  security_enabled = true
}

resource "azuread_group" "mfaexception" {
  display_name     = "SEC-CA-MFA Exception"
  description      = "Users in this group are excepted from MFA."
  security_enabled = true
}

resource "azuread_group" "dirsyncaccounts" {
  display_name     = "SEC-CA-Directory Synchronization Accounts"
  description      = "All Directory Synchronization Accounts"
  security_enabled = true
}

resource "azuread_group" "admins" {
  display_name     = "SEC-CA-All Admins"
  description      = "All admin accounts"
  security_enabled = true
  dynamic_membership {
    enabled = true
    rule    = var.admin_group_rule
  }
}

resource "azuread_administrative_unit_member" "member1" {
  administrative_unit_object_id = data.azuread_administrative_unit.restricted_groups.object_id
  member_object_id = azuread_group.blockedaccounts.object_id
}

resource "azuread_administrative_unit_member" "member2" {
  administrative_unit_object_id = data.azuread_administrative_unit.restricted_groups.object_id
  member_object_id = azuread_group.legacyauth.object_id
}

resource "azuread_administrative_unit_member" "member3" {
  administrative_unit_object_id = data.azuread_administrative_unit.restricted_groups.object_id
  member_object_id = azuread_group.mfaexception.object_id
}

resource "azuread_administrative_unit_member" "member4" {
  administrative_unit_object_id = data.azuread_administrative_unit.restricted_groups.object_id
  member_object_id = azuread_group.dirsyncaccounts.object_id
}

resource "azuread_administrative_unit_member" "member5" {
  administrative_unit_object_id = data.azuread_administrative_unit.restricted_groups.object_id
  member_object_id = azuread_group.admins.object_id
}