#region "Global CA001 - CA099"

resource "azuread_conditional_access_policy" "CA001" {
  display_name = "CA001 - Global - BLOCK - Legacy Authentication"
  state        = "enabled"
  conditions {
    client_app_types = [
      "exchangeActiveSync",
      "other"
    ]
    applications {
      included_applications = ["All"]
    }
    locations {
      included_locations = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

# resource "azuread_conditional_access_policy" "CA002" {
#   display_name = "CA002 - Global - BLOCK - Auth Flow"
#   state        = "disabled"
#   conditions {
#     client_app_types = ["all"]
#     applications {
#       included_applications = ["all"]
#     }
#     locations {
#       included_locations = ["all"]
#     }
#     users {
#       excluded_groups = [data.azuread_group.breakglassgroup.object_id]
#       included_users  = ["all"]
#     }
#   }
#   grant_controls {
#     operator = "OR"
#   }
# }

resource "azuread_conditional_access_policy" "CA003" {
  display_name = "CA003 - Global - BLOCK - Unsupported device platform"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    platforms {
      included_platforms = ["all"]
      excluded_platforms = [
        "android",
        "iOS",
        "linux",
        "macOS",
        "windows"
      ]
    }
    applications {
      included_applications = ["All"]
    }
    locations {
      included_locations = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA004" {
  display_name = "CA004 - Global - GRANT - Require MFA"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      excluded_applications = [
        data.azuread_application.ms_intune.client_id,
        data.azuread_application.ms_intune_enrollment.client_id,
        data.azuread_application.winstorebusiness.client_id,
        data.azuread_application.azvm_signin.client_id,
      ]
      included_applications = ["All"]
    }
    locations {
      included_locations = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id,
        azuread_group.dirsyncaccounts.object_id
      ]
      included_users = ["All"]
      excluded_guests_or_external_users {
        guest_or_external_user_types = [
          "internalGuest",
          "b2bCollaborationGuest",
          "b2bCollaborationMember",
          "b2bDirectConnectUser",
          "otherExternalUser",
          "serviceProvider"
        ]
      }
    }
  }
  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA005" {
  display_name = "CA005 - Global - BLOCK - Explicitly Blocked Accounts"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_groups = [
        azuread_group.blockedaccounts.object_id
      ]
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA006" {
  display_name = "CA006 - Global - BLOCK - Bad Locations"
  state        = "enabled"
  conditions {
    client_app_types = [
      "browser",
      "mobileAppsAndDesktopClients",
      "easSupported",
      "other"
    ]
    applications {
      included_applications = ["All"]
    }
    devices {
      filter {
        mode = "include"
        rule = "device.trustType -ne \"ServerAD\" -or device.isCompliant -eq False"
      }
    }
    locations {
      included_locations = [
        azuread_named_location.blocked_locations.id
      ]
    }
    platforms {
      included_platforms = ["all"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA007" {
  display_name = "CA007 - Global - BLOCK - Blocked Countries"
  state        = "enabled"
  conditions {
    client_app_types = [
      "exchangeActiveSync",
      "browser",
      "mobileAppsAndDesktopClients",
      "other"
    ]
    applications {
      included_applications = ["All"]
    }
    devices {
      filter {
        mode = "include"
        rule = "device.trustType -ne \"ServerAD\" -or device.isCompliant -eq False"
      }
    }
    locations {
      included_locations = [
        azuread_named_location.blocked_countries.id
      ]
    }
    platforms {
      included_platforms = ["all"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA008" {
  display_name = "CA008 - Global - SESSION - Sign-In Frequency"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
      excluded_guests_or_external_users {
        guest_or_external_user_types = [
          "internalGuest",
          "b2bCollaborationGuest",
          "b2bCollaborationMember",
          "b2bDirectConnectUser",
          "otherExternalUser",
          "serviceProvider"
        ]
        external_tenants {
          members         = []
          membership_kind = "all"
        }
      }
    }
  }
  session_controls {
    sign_in_frequency                     = 30
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
    sign_in_frequency_interval            = "timeBased"
    sign_in_frequency_period              = "days"
  }
}

resource "azuread_conditional_access_policy" "CA009" {
  display_name = "CA009 - Global - GRANT - Sign-In Risk Require MFA"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    sign_in_risk_levels = [
      "high",
      "medium"
    ]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
    }
  }
  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
  session_controls {
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
    sign_in_frequency_interval            = "everyTime"
  }
}

resource "azuread_conditional_access_policy" "CA010" {
  display_name = "CA010 - Global - GRANT - High-Risk User Password Change"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    user_risk_levels = ["high"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_users = ["All"]
    }
  }
  grant_controls {
    built_in_controls = ["mfa", "passwordChange"]
    operator          = "AND"
  }
  session_controls {
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
    sign_in_frequency_interval            = "everyTime"
  }
}

resource "azuread_conditional_access_policy" "CA011" {
  display_name = "CA011 - Global - GRANT - Require MFA for Intune Enrollment"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = [
        data.azuread_application.ms_intune.client_id,
        data.azuread_application.ms_intune_enrollment.client_id
      ]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
    }
  }
  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

#endregion

#region "Admins CA100 - CA199"

resource "azuread_conditional_access_policy" "CA100" {
  display_name = "CA100 - Admins - GRANT - Break Glass Accounts "
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      included_groups = [
        var.breakglass_group_id
      ]
    }
  }
  grant_controls {
    authentication_strength_policy_id = azuread_authentication_strength_policy.breakglasspolicy.id
    operator                          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA101" {
  display_name = "CA101 - Admins - GRANT - Require MFA"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      excluded_applications = [
        data.azuread_application.azvm_signin.client_id
      ]
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id,
        azuread_group.dirsyncaccounts.object_id
      ]
      included_groups = [
        azuread_group.admins.object_id
      ]
      included_roles = concat(
        jsondecode(file("${path.module}/assets/entra_roles_controplane.json")),
        jsondecode(file("${path.module}/assets/entra_roles_managementplane.json"))
      )
    }
  }
  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
  session_controls {
    sign_in_frequency                     = 10
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
    sign_in_frequency_interval            = "timeBased"
    sign_in_frequency_period              = "hours"
  }
}

resource "azuread_conditional_access_policy" "CA102" {
  display_name = "CA102 - Admins - BLOCK - Allow access to control plane only from known locations"
  state        = "enabledForReportingButNotEnforced"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    locations {
      excluded_locations = [
        azuread_named_location.controlplane_access
      ]
      included_locations = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_roles = jsondecode(file("${path.module}/assets/entra_roles_controplane.json"))
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA103" {
  display_name = "CA103 - Admins - BLOCK - Allow access to management plane only from known locations"
  state        = "enabledForReportingButNotEnforced"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    locations {
      excluded_locations = [
        azuread_named_location.managementplane_access
      ]
      included_locations = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_roles = jsondecode(file("${path.module}/assets/entra_roles_managementplane.json"))
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA104" {
  display_name = "CA104 - Admins - BLOCK - High-risk admin sign-ins"
  state        = "enabled"
  conditions {
    client_app_types    = ["all"]
    sign_in_risk_levels = ["high"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_groups = [
        azuread_group.admins.object_id
      ]
      included_roles = concat(
        jsondecode(file("${path.module}/assets/entra_roles_controplane.json")),
        jsondecode(file("${path.module}/assets/entra_roles_managementplane.json"))
      )
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA105" {
  display_name = "CA105 - Admins - BLOCK - High-risk admin users"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    user_risk_levels = ["high"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_groups = [
        azuread_group.admins
      ]
      included_roles = concat(
        jsondecode(file("${path.module}/assets/entra_roles_controplane.json")),
        jsondecode(file("${path.module}/assets/entra_roles_managementplane.json"))
      )
    }
  }
  grant_controls {
    built_in_controls = ["block"]
    operator          = "OR"
  }
}

#endregion

#region "Internals CA200 - CA299"

#endregion

#region "Externals CA300 - CA399"

#endregion

#region "GuestUsers CA400 - CA499"

resource "azuread_conditional_access_policy" "CA401" {
  display_name = "CA401 - Guests - GRANT - Require MFA"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_guests_or_external_users {
        guest_or_external_user_types = [
          "internalGuest",
          "b2bCollaborationGuest",
          "b2bCollaborationMember",
          "b2bDirectConnectUser",
          "otherExternalUser",
          "serviceProvider"
        ]
      }
    }
  }
  grant_controls {
    built_in_controls = ["mfa"]
    operator          = "OR"
  }
}

resource "azuread_conditional_access_policy" "CA402" {
  display_name = "CA402 - Guests - SESSION - Sign-In Frequency"
  state        = "enabled"
  conditions {
    client_app_types = ["all"]
    applications {
      included_applications = ["All"]
    }
    users {
      excluded_groups = [
        data.azuread_group.breakglassgroup.object_id
      ]
      included_guests_or_external_users {
        guest_or_external_user_types = [
          "internalGuest",
          "b2bCollaborationGuest",
          "b2bCollaborationMember",
          "b2bDirectConnectUser",
          "otherExternalUser",
          "serviceProvider"
        ]
      }
    }
  }
  session_controls {
    persistent_browser_mode               = "never"
    sign_in_frequency                     = 10
    sign_in_frequency_authentication_type = "primaryAndSecondaryAuthentication"
    sign_in_frequency_interval            = "timeBased"
    sign_in_frequency_period              = "hours"
  }
}

#endregion

#region "GuestAdmins CA500 - CA599"

#endregion
