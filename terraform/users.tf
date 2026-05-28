resource "aws_iam_user" "this" {
  for_each = var.users

  name = each.key
  path = each.value.path

  tags = each.value.tags
}

resource "aws_iam_user_group_membership" "this" {
  for_each = local.user_group_memberships

  user   = aws_iam_user.this[each.value.username].name
  groups = [aws_iam_group.this[each.value.group].name]
}
