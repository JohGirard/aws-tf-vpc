###########################
# Databases
###########################

resource "aws_subnet" "database" {
  count = var.subnets.database_subnets ? local.az_count : 0

  vpc_id                          = aws_vpc.main.id
  assign_ipv6_address_on_creation = var.vpc.assign_generated_ipv6_cidr_block
  map_public_ip_on_launch         = false

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  cidr_block = cidrsubnet(var.vpc.cidr_block, local.az_count + 1, (local.az_count * 3 + count.index))

  tags = merge(
    {
      "Name" : "${var.environment}-database-${local.alphabet[count.index]}"
    },
    local.tags
  )
}

resource "aws_route_table" "database" {
  count = var.subnets.database_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" : "${var.environment}-database"
    },
    local.tags
  )
}

resource "aws_route_table_association" "databases" {
  count = var.subnets.database_subnets ? length(aws_subnet.database) : 0

  route_table_id = aws_route_table.database[0].id
  subnet_id      = aws_subnet.database[count.index].id
}

###########################
# Database Subnets Group
###########################

resource aws_db_subnet_group rds {
  count = var.subnets.private_subnets ? 1 : 0

  name        = "${var.environment}-database"
  subnet_ids  = aws_subnet.database.*.id
  description = "Default RDS Subnet Groups"
}

resource aws_elasticache_subnet_group cache {
  count = var.subnets.private_subnets ? 1 : 0

  name        = "${var.environment}-database"
  subnet_ids  = aws_subnet.database.*.id
  description = "Default Elasticache Subnet Groups"
}

resource aws_redshift_subnet_group redshit {
  count = var.subnets.private_subnets ? 1 : 0

  name        = "${var.environment}-database"
  subnet_ids  = aws_subnet.database.*.id
  description = "Default Redshift Subnet Groups"
  tags        = local.tags
}
