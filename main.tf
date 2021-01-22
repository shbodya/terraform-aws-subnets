locals {
  vpc_id                   = var.vpc_id
  availability_zones_count = length(var.availability_zones)
}