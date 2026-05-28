variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "users" {
  description = "Map of IAM users to create. Key is the username."
  type = map(object({
    groups = optional(list(string), [])
    path   = optional(string, "/")
    tags   = optional(map(string), {})
  }))
  default = {}
}

variable "groups" {
  description = "Map of IAM groups to create. Key is the group name."
  type = map(object({
    path                = optional(string, "/")
    managed_policy_arns = optional(list(string), [])
    inline_policy_json  = optional(string, null)
  }))
  default = {}
}

variable "custom_policies" {
  description = "Map of custom IAM managed policies to create. Key is the policy name."
  type = map(object({
    description = optional(string, "")
    path        = optional(string, "/")
    policy_json = string
  }))
  default = {}
}

variable "service_roles" {
  description = "Map of IAM roles assumed by AWS services. Key is the role name."
  type = map(object({
    description          = optional(string, "")
    trusted_services     = list(string)
    managed_policy_arns  = optional(list(string), [])
    inline_policy_json   = optional(string, null)
    path                 = optional(string, "/")
    max_session_duration = optional(number, 3600)
  }))
  default = {}
}

variable "cross_account_roles" {
  description = "Map of IAM roles assumed from other AWS accounts. Key is the role name."
  type = map(object({
    description          = optional(string, "")
    trusted_account_ids  = list(string)
    require_mfa          = optional(bool, false)
    managed_policy_arns  = optional(list(string), [])
    inline_policy_json   = optional(string, null)
    path                 = optional(string, "/")
    max_session_duration = optional(number, 3600)
  }))
  default = {}
}

variable "oidc_roles" {
  description = "Map of IAM roles for OIDC federated identities (e.g., GitHub Actions). Key is the role name."
  type = map(object({
    description          = optional(string, "")
    oidc_provider_arn    = string
    oidc_subjects        = list(string)
    managed_policy_arns  = optional(list(string), [])
    inline_policy_json   = optional(string, null)
    path                 = optional(string, "/")
    max_session_duration = optional(number, 3600)
  }))
  default = {}
}
