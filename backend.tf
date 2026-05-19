terraform {
  backend "s3" {
    bucket       = "mlops-terraform-backend-bucket-12345"
    key          = "terraform.tfstate"
    use_lockfile = true
  }
}

