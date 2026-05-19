data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "mlops_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "mlops_gw" {
  vpc_id = aws_vpc.mlops_vpc.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets["public_1"].id
}

resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.mlops_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value + 100)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value % 3]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.mlops_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value % 3]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mlops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mlops_gw.id
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mlops_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet_rt" {
  depends_on     = [aws_subnet.public_subnets]
  route_table_id = aws_route_table.public_rt.id
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
}

resource "aws_route_table_association" "private_subnet_rt" {
  depends_on     = [aws_subnet.private_subnets]
  route_table_id = aws_route_table.private_rt.id
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
}
