###################
# Security Groups #
###################

resource "aws_security_group" "ec2_security_groups" {
  for_each    = toset(["Training", "MLFlow", "Deployment"])
  name        = "${each.key}SG"
  description = "Allow connections to the ${each.key} server"
  vpc_id      = aws_vpc.mlops_vpc.id
}

resource "aws_security_group" "db_security_group" {
  name        = "DatabaseSG"
  description = "Allow Postgres connections"
  vpc_id      = aws_vpc.mlops_vpc.id
}

#################
# Ingress rules #
#################

resource "aws_vpc_security_group_ingress_rule" "ec2_security_group_allow_ssh_ipv4_ingress" {
  security_group_id = aws_security_group.ec2_security_groups["Deployment"].id
  cidr_ipv4         = var.allowed_cidr_source
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "mlflow_security_group_allow_mlflow_cidr" {
  security_group_id = aws_security_group.ec2_security_groups["MLFlow"].id
  cidr_ipv4         = var.allowed_cidr_source
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
}

resource "aws_vpc_security_group_ingress_rule" "mlflow_security_group_allow_servers" {
  security_group_id            = aws_security_group.ec2_security_groups["MLFlow"].id
  referenced_security_group_id = aws_security_group.ec2_security_groups["Training"].id
  from_port                    = 5000
  ip_protocol                  = "tcp"
  to_port                      = 5000
}

resource "aws_vpc_security_group_ingress_rule" "deployment_security_group_allow_fastapi" {
  security_group_id = aws_security_group.ec2_security_groups["Deployment"].id
  cidr_ipv4         = var.allowed_cidr_source
  from_port         = 8000
  ip_protocol       = "tcp"
  to_port           = 8000
}

resource "aws_vpc_security_group_ingress_rule" "db_security_group_allow_postgres" {
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4         = "${aws_instance.mlflow_server.private_ip}/32"
  from_port         = 5432
  ip_protocol       = "tcp"
  to_port           = 5432
}

################
# Egress rules #
################

resource "aws_vpc_security_group_egress_rule" "ec2_security_groups_allow_all" {
  for_each          = aws_security_group.ec2_security_groups
  security_group_id = each.value.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "db_security_group_allow_all" {
  security_group_id = aws_security_group.db_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
