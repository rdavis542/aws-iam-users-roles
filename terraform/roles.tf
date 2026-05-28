# ─── Service Roles ────────────────────────────────────────────────────────────

resource "aws_iam_role" "service" {
  for_each = var.service_roles

  name                 = each.key
  description          = each.value.description
  path                 = each.value.path
  max_session_duration = each.value.max_session_duration

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = each.value.trusted_services }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "service" {
  for_each = local.service_role_policy_attachments

  role       = aws_iam_role.service[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "service_inline" {
  for_each = { for k, v in var.service_roles : k => v if v.inline_policy_json != null }

  name   = "${each.key}-inline"
  role   = aws_iam_role.service[each.key].name
  policy = each.value.inline_policy_json
}

# ─── Cross-Account Roles ──────────────────────────────────────────────────────

resource "aws_iam_role" "cross_account" {
  for_each = var.cross_account_roles

  name                 = each.key
  description          = each.value.description
  path                 = each.value.path
  max_session_duration = each.value.max_session_duration

  assume_role_policy = data.aws_iam_policy_document.cross_account_trust[each.key].json
}

resource "aws_iam_role_policy_attachment" "cross_account" {
  for_each = local.cross_account_role_policy_attachments

  role       = aws_iam_role.cross_account[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "cross_account_inline" {
  for_each = { for k, v in var.cross_account_roles : k => v if v.inline_policy_json != null }

  name   = "${each.key}-inline"
  role   = aws_iam_role.cross_account[each.key].name
  policy = each.value.inline_policy_json
}

# ─── OIDC Roles ───────────────────────────────────────────────────────────────

resource "aws_iam_role" "oidc" {
  for_each = var.oidc_roles

  name                 = each.key
  description          = each.value.description
  path                 = each.value.path
  max_session_duration = each.value.max_session_duration

  assume_role_policy = data.aws_iam_policy_document.oidc_trust[each.key].json
}

resource "aws_iam_role_policy_attachment" "oidc" {
  for_each = local.oidc_role_policy_attachments

  role       = aws_iam_role.oidc[each.value.role_name].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_role_policy" "oidc_inline" {
  for_each = { for k, v in var.oidc_roles : k => v if v.inline_policy_json != null }

  name   = "${each.key}-inline"
  role   = aws_iam_role.oidc[each.key].name
  policy = each.value.inline_policy_json
}
