[![CircleCI](https://circleci.com/gh/JohGirard/aws-tf-vpc/tree/master.svg?style=svg)](https://circleci.com/gh/JohGirard/aws-tf-vpc/tree/master)

# aws-tf-vpc
Create a secure VPC

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| environment | Environment used in each tags | `string` | `"development"` | no |
| nat\_gateway\_enable | Use a NAT Gateway | `bool` | `false` | no |
| nat\_hight\_avaibility | Use a NAT Gateway/Instance in each Avaibility Zone | `bool` | `false` | no |
| nat\_instance\_type | Instance type if you want to use Instance as a NAT | `string` | `"t2.nano"` | no |
| subnets | Enable subnets by type | <pre>object({<br>    public_subnets   = bool<br>    private_subnets  = bool<br>    database_subnets = bool<br>  })</pre> | <pre>{<br>  "database_subnets": true,<br>  "private_subnets": true,<br>  "public_subnets": true<br>}</pre> | no |
| vpc | Map of VPC definition | <pre>object({<br>    cidr_block                       = any<br>    assign_generated_ipv6_cidr_block = bool<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| databases\_subnets\_cidr\_block | Private subnets list CIDR |
| databases\_subnets\_id | Private subnets list id |
| nat\_count | n/a |
| private\_subnets\_cidr\_block | Private subnets list CIDR with NAT |
| private\_subnets\_id | Private subnets list id with NAT |
| public\_subnets\_cidr\_block | Public subnets list CIDR |
| public\_subnets\_id | Public subnets list id |
| vpc\_id | Vpc id |
