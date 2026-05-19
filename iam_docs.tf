data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ec2_role_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "github_actions_role_documents" {
  for_each  = var.mlops-users
  policy_id = "UserRole-${each.key}"
  statement {
    principals {
      type = "Federated"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      ]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${each.value["repo"]}:ref:refs/heads/main"]
    }
  }
}

data "aws_iam_policy_document" "lambda_role_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
  }
}

data "aws_iam_policy_document" "mlflow_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:AbortMultipartUpload"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.artifact_storage.arn,
      "${aws_s3_bucket.artifact_storage.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "training_policy_document" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.data_storage.arn,
      "${aws_s3_bucket.data_storage.arn}/*",
    ]
  }
  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.artifact_storage.arn,
      "${aws_s3_bucket.artifact_storage.arn}/*"
    ]
  }
}

data "aws_iam_policy_document" "deployment_policy_document" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.model_storage.arn,
      "${aws_s3_bucket.model_storage.arn}/*",
    ]
  }
  statement {
    actions = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes"
    ]
    effect = "Allow"
    resources = [
      aws_sqs_queue.pull_release_queue.arn
    ]
  }
}

# data "aws_iam_policy_document" "ecr_pull_policy_document" {
#   statement {
#     actions = [
#       "ecr:ListImages",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:DescribeImages",
#       "ecr:BatchGetImage"
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
#   statement {
#     actions = [
#       "ecr:GetAuthorizationToken",
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
# }

data "aws_iam_policy_document" "github_actions_policy_documents" {
  for_each = var.mlops-users
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.artifact_storage.arn,
      "${aws_s3_bucket.artifact_storage.arn}/*"
    ]
  }
  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.model_storage.arn}/${each.value["project"]}*"
    ]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
    ]
    effect = "Allow"
    resources = [
      aws_ecr_repository.training_repos[each.key].arn
    ]
  }
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions = [
      "lambda:InvokeFunction",
    ]
    effect = "Allow"
    resources = [
      aws_lambda_function.training_lambda.arn
    ]
  }
}

data "aws_iam_policy_document" "pull_release_policy_document" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["sqs:SendMessage"]
    effect  = "Allow"
    resources = [
      aws_sqs_queue.pull_release_queue.arn
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.model_storage.arn]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:CreateTags",
      "iam:PassRole"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
