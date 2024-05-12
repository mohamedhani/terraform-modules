data "aws_iam_policy_document" "default" {

  statement {
    sid = "AllowCreateRoute53Record"
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
  }
  statement {
    sid = "AllowListonRoute53"
    resources = [
      "*"
    ]
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]
  }
}
