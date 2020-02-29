[![CircleCI](https://circleci.com/gh/JohGirard/aws-tf-vpc/tree/master.svg?style=svg)](https://circleci.com/gh/JohGirard/aws-tf-vpc/tree/master)

# Presentation

This module will create a 3 layers (or less) Network from scratch on Amazon Web Service. 
You have several choice:
    For a test account:
    - One NAT instance to avoid cost (you can stop your instance) 
    - One NAT instance on each Avaibility Zones to avoid cost (you can stop your instance)
    For staging account:
    - One NAT Gateway for a staging account
    For Production Account
    - One NAT instance on each Avaibility Zones to have a hight avaibility

# How to use it

```shell
export AWS_ACCESS_KEY_ID=<<YourAccessKeyId>>
export AWS_SECRET_ACCESS_KEY=<<YourSecretAccessKey>>
export AWS_DEFAULT_REGION=<<YourDefaultAwsRegion>>
export AWS_REGION=<<YourAwsRegion>>
export BUCKET_REGION=<<YourBucketS3TfstateRegionLocation>>
export BUCKET_TF_STATE=<<YourBucketS3Tfstate>>
export DYNAMODB_TABLE_LOCK=<<YourDynanoDBLock>>
```

Init your terraform fron the root folder

```shell
terraform init \
    -backend-config="bucket=${BUCKET_TF_STATE}" \
    -backend-config="dynamodb_table=${DYNAMODB_TABLE_LOCK}" \
    -backend-config="key=YourPath" \
    -backend-config="region=${BUCKET_REGION}"
```

Plan

```shell
terraform plan -var-file=environments/development/eu-west-1.tfvars -var-file=environments/development/global.tfvars
```

Apply

```shell
terraform apply -var-file=environments/development/eu-west-1.tfvars -var-file=environments/development/global.tfvars
```

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

# Improvement in coming

- Diagram
- Add Network Access List on each layers with best Pratices
- Endpoints
- Peering

# Projects link:-

In coming
