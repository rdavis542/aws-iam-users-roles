# ─── Users ────────────────────────────────────────────────────────────────────

output "user_arns" {
  description = "Map of IAM user names to ARNs"
  value       = { for k, v in aws_iam_user.this : k => v.arn }
}

output "user_names" {
  description = "List of IAM user names created"
  value       = keys(aws_iam_user.this)
}

# ─── Groups ───────────────────────────────────────────────────────────────────

output "group_arns" {
  description = "Map of IAM group names to ARNs"
  value       = { for k, v in aws_iam_group.this : k => v.arn }
}

output "group_ids" {
  description = "Map of IAM group names to unique IDs"
  value       = { for k, v in aws_iam_group.this : k => v.unique_id }
}

# ─── Custom Policies ──────────────────────────────────────────────────────────

output "custom_policy_arns" {
  description = "Map of custom policy names to ARNs"
  value       = { for k, v in aws_iam_policy.this : k => v.arn }
}

# ─── Service Roles ────────────────────────────────────────────────────────────

output "service_role_arns" {
  description = "Map of service role names to ARNs"
  value       = { for k, v in aws_iam_role.service : k => v.arn }
}

output "service_role_names" {
  description = "Map of service role names to role names (for attaching to resources)"
  value       = { for k, v in aws_iam_role.service : k => v.name }
}

# ─── Cross-Account Roles ──────────────────────────────────────────────────────

output "cross_account_role_arns" {
  description = "Map of cross-account role names to ARNs"
  value       = { for k, v in aws_iam_role.cross_account : k => v.arn }
}

# ─── OIDC Roles ───────────────────────────────────────────────────────────────

output "oidc_role_arns" {
  description = "Map of OIDC role names to ARNs"
  value       = { for k, v in aws_iam_role.oidc : k => v.arn }
}

# ─── Account ──────────────────────────────────────────────────────────────────

output "account_id" {
  description = "AWS account ID"
  value       = local.account_id
}
