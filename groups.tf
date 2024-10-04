data "azuread_group" "breakglassgroup" {
  object_id = var.breakglass_group_id
}

resource "azuread_group" "blockedaccounts" {
  display_name     = "SEC-CA-BlockedAccounts"
  description      = "Explicitly blocked accounts"
  security_enabled = true
}

resource "azuread_group" "legacyauth" {
  display_name     = "SEC-CA-LegacyAuth-Exception"
  description      = "Exception group to allow Legacy Authentication eg. for SMTP in Conditional Access"
  security_enabled = true
}

resource "azuread_group" "mfaexception" {
  display_name     = "SEC-CA-MFA-Exception"
  description      = "Users in this group are excepted from MFA."
  security_enabled = true
}

resource "azuread_group" "dirsyncaccounts" {
  display_name     = "SEC-CA-Directory Synchronization Accounts"
  description      = "All Directory Synchronization Accounts"
  security_enabled = true
}

resource "azuread_group" "admins" {
  display_name     = "SEC-CA-Admins"
  description      = "All admin accounts"
  security_enabled = true
  dynamic_membership {
    enabled = true
    rule    = "user.userPrincipalName -startsWith \"adm.\""
  }
}
