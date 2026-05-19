#########
# Roles #
#########

resource "aws_iam_role" "ec2_roles" {
  for_each           = toset(["Training", "Deployment", "MLFlow"])
  name               = "${each.key}Role"
  assume_role_policy = data.aws_iam_policy_document.ec2_role_document.json
}

resource "aws_iam_role" "github_actions_roles" {
  for_each           = data.aws_iam_policy_document.github_actions_role_documents
  name               = "${each.key}-GithubActionsRole"
  assume_role_policy = each.value.json
}

resource "aws_iam_role" "lambda_role" {
  name               = "LambdaEC2Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_role_document.json
}

#################
# Role policies #
#################

resource "aws_iam_role_policy" "github_actions_policies" {
  for_each = aws_iam_role.github_actions_roles
  name     = "AllowGithubActions"
  role     = each.value.id
  policy   = data.aws_iam_policy_document.github_actions_policy_documents[each.key].json
}

resource "aws_iam_role_policy" "training_resources_policy" {
  name   = "AllowTrainingResources"
  role   = aws_iam_role.ec2_roles["Training"].name
  policy = data.aws_iam_policy_document.training_policy_document.json
}

resource "aws_iam_role_policy" "mlflow_resources_policy" {
  name   = "AllowMLFlowResources"
  role   = aws_iam_role.ec2_roles["MLFlow"].name
  policy = data.aws_iam_policy_document.mlflow_policy_document.json
}

resource "aws_iam_role_policy" "deployment_resources_policy" {
  name   = "AllowDeploymentResources"
  role   = aws_iam_role.ec2_roles["Deployment"].name
  policy = data.aws_iam_policy_document.deployment_policy_document.json
}

resource "aws_iam_role_policy" "lambda_ec2_policy" {
  name   = "AllowLambdaEC2"
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

######################
# Policy attachments #
######################

resource "aws_iam_role_policy_attachment" "attach_allow_erc_pull_policy" {
  for_each   = aws_iam_role.ec2_roles
  role       = each.value.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_agent_policy" {
  role       = aws_iam_role.ec2_roles["Training"].id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

############
# Profiles #
############

resource "aws_iam_instance_profile" "ec2_profiles" {
  for_each = aws_iam_role.ec2_roles
  name     = "${each.key}Profile"
  role     = each.value.name
}
