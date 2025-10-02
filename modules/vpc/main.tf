resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = { Name = "${var.name}-vpc" }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags                    = { Name = "${var.name}-public-${count.index}" }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags              = { Name = "${var.name}-private-${count.index}" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.name}-igw" }
}

resource "aws_eip" "nat" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags   = { Name = "${var.name}-nat-eip" }
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags          = { Name = "${var.name}-nat" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.name}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.create_nat_gateway ? aws_nat_gateway.nat[0].id : null
  }
  tags = { Name = "${var.name}-private-rt" }
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

### VPC Endpoints (optional)
resource "aws_vpc_endpoint" "s3" {
  count             = var.create_endpoints ? 1 : 0
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.id}.s3"
  route_table_ids   = [aws_route_table.public.id]
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint" "ecr_api" {
  count              = var.create_endpoints ? 1 : 0
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${data.aws_region.current.id}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = []
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count              = var.create_endpoints ? 1 : 0
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${data.aws_region.current.id}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = []
}

data "aws_region" "current" {}
