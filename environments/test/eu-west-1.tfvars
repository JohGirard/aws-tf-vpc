vpc = {
  cidr_block                       = "10.0.0.0/21"
  assign_generated_ipv6_cidr_block = false
}

nat_instance_type    = "t3a.nano"
nat_gateway_enable   = false
nat_hight_avaibility = false
