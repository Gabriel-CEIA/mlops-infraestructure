resource "aws_ecr_repository" "training_repos" {
  for_each             = var.mlops-users
  name                 = "training/${each.value["project"]}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "deployment_repo" {
  name                 = "deployment/server"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
