###########################
# Private
###########################

resource "aws_subnet" "private" {
  count = var.subnets.private_subnets && var.subnets.public_subnets ? local.az_count : 0


  vpc_id                          = aws_vpc.main.id
  assign_ipv6_address_on_creation = var.vpc.assign_generated_ipv6_cidr_block
  map_public_ip_on_launch         = false

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  cidr_block = cidrsubnet(var.vpc.cidr_block, local.az_count + 1, (local.az_count * 2 + count.index))

  tags = merge(
    {
      "Name" : "${var.environment}-private-${local.alphabet[count.index]}"
    },
    local.tags
  )
}

resource "aws_route_table" "private" {
  count = var.subnets.private_subnets && var.subnets.public_subnets ? local.nat_count : 0

  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" : "${var.environment}-private-${local.alphabet[count.index]}"
    },
    local.tags
  )
}

resource "aws_route" "private" {
  count = var.subnets.private_subnets && var.subnets.public_subnets ? local.nat_count : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  instance_id    = var.nat_gateway_enable == false ? aws_instance.nat[count.index].id : null
  nat_gateway_id = var.nat_gateway_enable ? aws_nat_gateway.gw[count.index].id : null

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "privates_single_nat" {
  count = var.subnets.private_subnets && var.subnets.public_subnets && var.nat_hight_avaibility == false ? local.az_count : 0

  route_table_id = aws_route_table.private[0].id
  subnet_id      = aws_subnet.private[count.index].id
}

resource "aws_route_table_association" "privates_nat_ha" {
  count = var.subnets.private_subnets && var.subnets.public_subnets && var.nat_hight_avaibility == true ? local.nat_count : 0

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}
