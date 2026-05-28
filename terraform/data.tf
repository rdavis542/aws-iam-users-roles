data "aws_caller_identity" "current" {}

# Trust policy documents for cross-account roles
data "aws_iam_policy_document" "cross_account_trust" {
  for_each = var.cross_account_roles

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [for id in each.value.trusted_account_ids : "arn:aws:iam::${id}:root"]
    }

    dynamic "condition" {
      for_each = each.value.require_mfa ? [1] : []
      content {
        test     = "Bool"
        variable = "aws:MultiFactorAuthPresent"
        values   = ["true"]
      }
    }
  }
}

# Trust policy documents for OIDC roles
data "aws_iam_policy_document" "oidc_trust" {
  for_each = var.oidc_roles

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [each.value.oidc_provider_arn]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(each.value.oidc_provider_arn, "/^.*provider\\//", "")}:sub"
      values   = each.value.oidc_subjects
    }
  }
}
