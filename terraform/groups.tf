resource "aws_iam_group" "this" {
  for_each = var.groups

  name = each.key
  path = each.value.path
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = local.group_policy_attachments

  group      = aws_iam_group.this[each.value.group_name].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_group_policy" "inline" {
  for_each = { for k, v in var.groups : k => v if v.inline_policy_json != null }

  name   = "${each.key}-inline"
  group  = aws_iam_group.this[each.key].name
  policy = each.value.inline_policy_json
}
