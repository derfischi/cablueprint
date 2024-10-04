# Azure Virtual Desktop
data "azuread_application" "avd" {
  client_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
}

# Microsoft Intune
data "azuread_application" "ms_intune" {
  client_id = "0000000a-0000-0000-c000-000000000000"
}

# Microsoft Intune Enrollment
data "azuread_application" "ms_intune_enrollment" {
  client_id = "d4ebce55-015a-49b5-a083-c84d1797ae8c"
}

# Microsoft Azure Virtual Machine Sign-In
data "azuread_application" "azvm_signin" {
  client_id = "372140e0-b3b7-4226-8ef9-d57986796201"
}
