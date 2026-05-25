output "mlflow_server_public_ip" {
  description = "Public IP of MLFlow server"
  value       = "http://${aws_instance.mlflow_server.public_ip}:5000"
}

output "deployment_server_public_ip" {
  description = "Public IP of deployment server"
  value       = one(aws_instance.deployment_server[*].public_ip)
}

output "training_repository" {
  description = "URI of the training image repositories"
  value       = [for repo in aws_ecr_repository.training_repos : repo.repository_url]
}

output "lambda_function_name" {
  description = "Lambda function that launches new trining instances"
  value       = aws_lambda_function.training_lambda.function_name
}

output "user_roles" {
  description = "ARN value of each Github Actions role"
  value       = [for role in aws_iam_role.github_actions_roles : role.arn]
}
