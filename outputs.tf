output "mlflow_server_uri" {
  description = "URI of MLFlow server"
  value       = "http://${aws_instance.mlflow_server.public_ip}:5000"
}

output "deployment_server_uri" {
  description = "URI of deployment server"
  value       = var.deploy ? "http://${one(aws_instance.deployment_server[*].public_ip)}:8000" : null
}

output "lambda_function_name" {
  description = "Lambda function that launches new training instances"
  value       = aws_lambda_function.training_lambda.function_name
}

output "user_roles" {
  description = "Name of each Github Actions role"
  value       = [for role in aws_iam_role.github_actions_roles : role.name]
}

output "user_projects" {
  description = "Id of each project registered"
  value       = [for user in var.mlops-users : user["project"]]
}
