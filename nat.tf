locals {
  nat_gateways_count = var.nat_gateway_enabled ? local.availability_zones_count : 0
  nat_gateway_eip_count = local.nat_gateways_count
}

resource "aws_eip" "default" {
  count = local.nat_gateway_eip_count
  vpc   = true

  tags = merge(var.tags,
    {
      "Name" = "nat-${element(var.availability_zones, count.index)}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = local.nat_gateway_eip_count
  allocation_id = element(aws_eip.default.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(var.tags,
    {
      "Name" = "natgw-${element(var.availability_zones, count.index)}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "default" {
  count                  = local.nat_gateways_count
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.default.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]

  timeouts {
    create = "2m"
    delete = "5m"
  }
}
