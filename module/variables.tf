variable "vpc" {
  type = object({
    cidr_block                       = any
    assign_generated_ipv6_cidr_block = bool
  })

  default = {
    cidr_block                       = ""
    assign_generated_ipv6_cidr_block = true
  }
}
