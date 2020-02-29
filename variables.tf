variable "environment" {
  type        = string
  default     = "development"
  description = "Environment used in each tags"
}

variable "vpc" {
  type = object({
    cidr_block                       = any
    assign_generated_ipv6_cidr_block = bool
  })

  description = "Map of VPC definition"
}

variable "subnets" {
  type = object({
    public_subnets   = bool
    private_subnets  = bool
    database_subnets = bool
  })

  default = {
    public_subnets   = true
    private_subnets  = true
    database_subnets = true
  }

  description = "Enable subnets by type"
}

variable "nat_instance_type" {
  type        = string
  default     = "t2.nano"
  description = "Instance type if you want to use Instance as a NAT"
}

variable "nat_gateway_enable" {
  type        = bool
  default     = false
  description = "Use a NAT Gateway"
}

variable "nat_hight_avaibility" {
  type        = bool
  default     = false
  description = "Use a NAT Gateway/Instance in each Avaibility Zone"
}
