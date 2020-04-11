###########################
# NAT INSTANCE
###########################
resource "aws_instance" "nat" {
  count = var.subnets.private_subnets && var.subnets.public_subnets && var.nat_gateway_enable == false ? local.nat_count : 0

  ami                         = data.aws_ami.nat.id
  instance_type               = var.nat_instance_type
  source_dest_check           = false
  subnet_id                   = aws_subnet.public[count.index].id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.nat[count.index].id]

  tags = merge(
    {
      "Name" : "${var.environment}-NAT-${local.alphabet[count.index]}",
      "Autostop" : true
    },
    local.tags
  )
}

###########################
# SECURITY GROUPS
###########################

resource "aws_security_group" "nat" {
  count = var.subnets.private_subnets && var.subnets.public_subnets && var.nat_gateway_enable == false ? local.nat_count : 0

  name        = "NatInstance-${local.alphabet[count.index]}"
  description = "Access to internet via nat instance for private nodes"
  vpc_id      = aws_vpc.main.id

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow only internet access from private nat subnet
  dynamic "ingress" {
    for_each = var.nat_hight_avaibility == false ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [for value in aws_subnet.private : value.cidr_block]
    }
  }

  dynamic "ingress" {
    for_each = var.nat_hight_avaibility ? [1] : []
    content {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["${aws_subnet.private[count.index].cidr_block}"]
    }
  }

  tags = merge(
    {
      "Name" : "${var.environment}-Nat-${local.alphabet[count.index]}"
    },
    local.tags
  )
}
