variable "entra_tenant_id" {
  description = "Object ID of the target Entra ID tenant."
}

variable "breakglass_group_id" {
  description = "Object ID of the break glass account security group."
}

variable "restricted_groups_adminunit_id" {
  description = "Object ID of the restricted admin unit to safeguard groups used in CA policies."
}

variable "admin_group_rule" {
  description = "Dynamic membership rule for the admin user group."
  default = "user.userPrincipalName -match \"^adm\\..*@.*$\""
}