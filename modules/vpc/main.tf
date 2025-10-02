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
  security_group_ids = var.vpce_security_group_id != "" ? [var.vpce_security_group_id] : [aws_security_group.vpce[0].id]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  count              = var.create_endpoints ? 1 : 0
  vpc_id             = aws_vpc.main.id
  service_name       = "com.amazonaws.${data.aws_region.current.id}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private[*].id
  security_group_ids = var.vpce_security_group_id != "" ? [var.vpce_security_group_id] : [aws_security_group.vpce[0].id]
}

resource "aws_security_group" "vpce" {
  count       = var.create_endpoints && var.vpce_security_group_id == "" ? 1 : 0
  name        = "${var.name}-vpce-sg"
  description = "Security group for VPC interface endpoints (ECR)"
  vpc_id      = aws_vpc.main.id

  # Allow ECS tasks (in VPC) to reach endpoints on 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  # Allow all outbound from the endpoint SG
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.name}-vpce-sg" }
}

/* When we create the VPCE SG, optionally create SG-to-SG ingress rules allowing
   the provided source security groups to reach port 443 on the endpoint SG. */
resource "aws_security_group_rule" "vpce_allow_from_sgs" {
  count = var.create_endpoints && var.vpce_security_group_id == "" ? length(var.vpce_allowed_source_security_group_ids) : 0

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vpce[0].id
  source_security_group_id = var.vpce_allowed_source_security_group_ids[count.index]
  description              = "Allow source SG to reach VPCE on 443"
}

data "aws_region" "current" {}
