locals {
  account_id = data.aws_caller_identity.current.account_id

  # Flatten user → group memberships into a map for for_each
  user_group_memberships = {
    for pair in flatten([
      for username, user in var.users : [
        for group in user.groups : {
          key      = "${username}:${group}"
          username = username
          group    = group
        }
      ]
    ]) : pair.key => pair
  }

  # Flatten group → managed policy attachments into a map for for_each
  group_policy_attachments = {
    for pair in flatten([
      for group_name, group in var.groups : [
        for policy_arn in group.managed_policy_arns : {
          key        = "${group_name}:${policy_arn}"
          group_name = group_name
          policy_arn = policy_arn
        }
      ]
    ]) : pair.key => pair
  }

  # Flatten service role → managed policy attachments
  service_role_policy_attachments = {
    for pair in flatten([
      for role_name, role in var.service_roles : [
        for policy_arn in role.managed_policy_arns : {
          key        = "${role_name}:${policy_arn}"
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : pair.key => pair
  }

  # Flatten cross-account role → managed policy attachments
  cross_account_role_policy_attachments = {
    for pair in flatten([
      for role_name, role in var.cross_account_roles : [
        for policy_arn in role.managed_policy_arns : {
          key        = "${role_name}:${policy_arn}"
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : pair.key => pair
  }

  # Flatten OIDC role → managed policy attachments
  oidc_role_policy_attachments = {
    for pair in flatten([
      for role_name, role in var.oidc_roles : [
        for policy_arn in role.managed_policy_arns : {
          key        = "${role_name}:${policy_arn}"
          role_name  = role_name
          policy_arn = policy_arn
        }
      ]
    ]) : pair.key => pair
  }
}
