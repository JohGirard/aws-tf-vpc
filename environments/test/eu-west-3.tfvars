vpc = {
  cidr_block                       = "10.0.8.0/21"
  assign_generated_ipv6_cidr_block = false
}

nat_instance_type    = "t2.nano"
nat_gateway_enable   = false
nat_hight_avaibility = false
