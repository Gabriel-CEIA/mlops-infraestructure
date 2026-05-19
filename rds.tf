resource "aws_db_subnet_group" "db_subnets" {
  name = "db_subnet_group"
  subnet_ids = [
    aws_subnet.private_subnets["private_1"].id,
    aws_subnet.private_subnets["private_2"].id
  ]
}

resource "aws_db_instance" "tracking_database" {
  identifier             = "tracking-database"
  allocated_storage      = 10
  db_name                = "backend"
  engine                 = "postgres"
  engine_version         = "16.13"
  instance_class         = "db.t3.micro"
  username               = var.mlflow_db_user
  password               = var.mlflow_db_passwd
  vpc_security_group_ids = ["${aws_security_group.db_security_group.id}"]
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  skip_final_snapshot    = true
  multi_az               = true
}
