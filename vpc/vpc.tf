module "base_label" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "ll"
}

module "label_vpc" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "vpc"
  attributes = ["main"]
}
module "label_public_subnets" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "subnet"
  attributes = ["main", "public"] 
}
module "label_private_subnets" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "subnet"
  attributes = ["main", "private"] 
}
module "label_internet_gateway" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "internetgateway"
  attributes = ["main", "1"] 
}
module "label_eip" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "vpc"
  attributes = ["main", "eip"] 
}
module "label_natgateway" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "vpc"
  attributes = ["main", "natgateway"] 
}
module "label_routetable" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "vpc"
  attributes = ["main", "routetable"] 
}
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = module.label_vpc.tags
}

# =========================
# Create your subnets here
# =========================
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.main.id

  tags = module.label_internet_gateway.tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  # availability_zone = element(data.aws_availability_zones.available.names, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 0)
  map_public_ip_on_launch = true
  tags = module.label_public_subnets.tags
}


resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 4, 1)
  tags = module.label_private_subnets.tags
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
  tags = module.label_eip.tags
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_gateway_eip.id
  tags = module.label_natgateway.tags
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = module.label_routetable.tags
}

resource "aws_route" "private_route" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  tags = module.label_routetable.tags
}

resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.internet-gateway.id
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
