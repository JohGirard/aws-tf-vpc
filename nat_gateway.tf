resource "aws_eip" "nat" {
  count = var.subnets.private_subnets && var.nat_gateway_enable && var.subnets.public_subnets ? local.az_count : 0

  vpc = true

  tags = merge(
    {
      "Name" : "${var.environment}-Nat-${local.alphabet[count.index]}"
    },
    local.tags
  )
}

resource "aws_nat_gateway" "gw" {
  count = var.subnets.private_subnets && var.nat_gateway_enable && var.subnets.public_subnets ? local.az_count : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      "Name" : "${var.environment}-Nat-${local.alphabet[count.index]}"
    },
    local.tags
  )
}
