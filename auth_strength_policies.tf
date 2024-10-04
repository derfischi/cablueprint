resource "azuread_authentication_strength_policy" "breakglasspolicy" {
  display_name = "Break Glass authentication"
  description = "Authentication strength for break glass accounts."
  allowed_combinations = [
    "fido2"
  ]
}

resource "azuread_authentication_strength_policy" "controlplane" {
  display_name = "Control plane authentication"
  description = "Authentication strength for control plane access."
  allowed_combinations = [
    "fido2",
    "windowsHelloForBusiness",
    "temporaryAccessPassOneTime"
  ]
}

resource "azuread_authentication_strength_policy" "managementplane" {
  display_name = "Management plane authentication"
  description = "Authentication strength for management plane access."
  allowed_combinations = [
    "fido2",
    "windowsHelloForBusiness",
    "temporaryAccessPassOneTime",
    "password,microsoftAuthenticatorPush"
  ]
}