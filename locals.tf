locals {
  tags = {
    Environment = var.environment
  }

  az_count  = length(data.aws_availability_zones.available.names)
  nat_count = var.nat_hight_avaibility ? local.az_count : 1
  alphabet  = ["a", "b", "c", "d", "e", "f", "g", "h"]
}

output "nat_count" {
  value = local.nat_count
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "nat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }
  owners = ["amazon"]
}
