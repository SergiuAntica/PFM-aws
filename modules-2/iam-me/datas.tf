data "aws_iam_policy_document" "this" {
  statement {
    actions = [var.actions]

    principals {
      type        = var.type
      identifiers = [var.identifiers]
    }
  }
}
