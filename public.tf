resource "aws_subnet" "public" {
  count             = local.availability_zones_count
  vpc_id            = local.vpc_id
  availability_zone = element(var.availability_zones, count.index)

  cidr_block = element(var.public_cidr_blocks, count.index)

  map_public_ip_on_launch = true

  tags = merge(var.tags,
    {
      "Name" = "public-${element(var.availability_zones, count.index)}"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = var.tags
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id

  timeouts {
    create = "2m"
    delete = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count          = local.availability_zones_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_network_acl" "public" {
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.public.*.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  tags = var.tags
}