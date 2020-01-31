resource "aws_vpc" "main" {
  cidr_block                       = var.vpc.cidr_block
  assign_generated_ipv6_cidr_block = var.vpc.assign_generated_ipv6_cidr_block
}
