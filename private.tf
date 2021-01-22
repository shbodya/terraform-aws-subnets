resource "aws_subnet" "private" {
  count  = local.availability_zones_count
  vpc_id = local.vpc_id

  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = element(var.private_cidr_blocks, count.index)

  tags = merge(
    var.tags,
    {
      "Name" = "private-${element(var.availability_zones, count.index)}"
    }
  )
}

resource "aws_route_table" "private" {
  count  = local.availability_zones_count
  vpc_id = local.vpc_id

  tags = merge(var.tags,
    {
      "Name" = "private-${element(var.availability_zones, count.index)}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count          = local.availability_zones_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_network_acl" "private" {
  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.private.*.id

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