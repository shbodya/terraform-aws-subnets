output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private.*.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways created"
  value       = aws_nat_gateway.default.*.id
}

output "nat_gateway_public_ips" {
  description = "EIP of the NAT Gateway"
  value       = aws_eip.default.*.public_ip
}

output "availability_zones" {
  description = "List of Availability Zones"
  value       = var.availability_zones
}
