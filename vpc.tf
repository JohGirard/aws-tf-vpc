resource "aws_vpc" "main" {
  cidr_block                       = var.vpc.cidr_block
  assign_generated_ipv6_cidr_block = var.vpc.assign_generated_ipv6_cidr_block

  tags = merge(
    {
      "Name" : "${var.environment}"
    },
    local.tags
  )
}

# Internet Gateway

resource "aws_internet_gateway" "main" {
  count = var.subnets.public_subnets ? 1 : 0


  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" : "${var.environment}-itg"
    },
    local.tags
  )
}
