variable "vpc_cidr" {
  type        = string
  description = "CIDR Block used by the MLOps VPC"
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  type        = map(number)
  description = "Map of public subnets"
  default = {
    "public_1" = 1
  }
}

variable "private_subnets" {
  type        = map(number)
  description = "Map of private subnets"
  default = {
    "private_1" = 1
    "private_2" = 2
    "private_3" = 3
  }
}

variable "allowed_cidr_source" {
  type        = string
  description = "CIDR Block used to allow external access. (Change on production)"
  default     = "0.0.0.0/0"
}

variable "mlflow_db_user" {
  type        = string
  sensitive   = true
  description = "Password used for the MLFlow database"
  default     = "mlflow"
}

variable "mlflow_db_passwd" {
  type        = string
  sensitive   = true
  description = "Password used for the MLFlow database"
  default     = "password"
}

variable "deploy" {
  type        = bool
  description = "Indicate if the deployment server should be created, set to 'true' once the deployment image has been pushed to the ECR repository"
  default     = false
}

variable "mlops-users" {
  type = map(object({
    project = string
    repo    = string
  }))
  description = "Users of the MLOps infraestructure (users are externally mantined and created)"
}
