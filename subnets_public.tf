###########################
# Public
###########################

resource "aws_subnet" "public" {
  count = var.subnets.public_subnets ? local.az_count : 0

  vpc_id                          = aws_vpc.main.id
  assign_ipv6_address_on_creation = var.vpc.assign_generated_ipv6_cidr_block
  map_public_ip_on_launch         = true

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  cidr_block = cidrsubnet(var.vpc.cidr_block, local.az_count + 1, count.index)

  tags = merge(
    {
      "Name" : "${var.environment}-public-${local.alphabet[count.index]}"
    },
    local.tags
  )
}

###########################
# Route
###########################

resource "aws_route_table" "public" {
  count = var.subnets.public_subnets ? 1 : 0

  vpc_id = aws_vpc.main.id
  tags = merge(
    {
      "Name" : "${var.environment}-public"
    },
    local.tags
  )
}

resource "aws_route" "public_internet_gateway" {
  count = var.subnets.public_subnets ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "publics" {
  count = var.subnets.public_subnets ? length(aws_subnet.public) : 0

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}

###########################
# NACL
###########################

resource aws_network_acl public {
  count = var.subnets.public_subnets ? 1 : 0

  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.public.*.id

  tags = merge(
    {
      "Name" : "${var.environment}-public"
    },
    local.tags
  )
}

resource aws_network_acl_rule inbound_http_public {
  count = var.subnets.public_subnets ? length(aws_subnet.public) : 0

  network_acl_id = aws_network_acl.public.0.id
  rule_number    = 200 + count.index
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource aws_network_acl_rule inbound_https_public {
  count = var.subnets.public_subnets ? length(aws_subnet.public) : 0

  network_acl_id = aws_network_acl.public.0.id
  rule_number    = 200 + count.index
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource aws_network_acl_rule outbound_public {
  count = var.subnets.public_subnets ? length(aws_subnet.public) : 0

  network_acl_id = aws_network_acl.public.0.id
  rule_number    = 200 + count.index
  egress         = true
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
}
