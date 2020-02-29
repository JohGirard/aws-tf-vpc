vpc = {
  cidr_block                       = "10.1.0.0/21"
  assign_generated_ipv6_cidr_block = false
}

nat_instance_type    = "t3a.nano"
nat_gateway_enable   = false
nat_hight_avaibility = false

subnets = {
  public_subnets   = true
  private_subnets  = true
  database_subnets = true
}
