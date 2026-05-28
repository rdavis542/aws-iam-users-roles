resource "aws_iam_policy" "this" {
  for_each = var.custom_policies

  name        = each.key
  description = each.value.description
  path        = each.value.path
  policy      = each.value.policy_json
}
