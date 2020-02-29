output "vpc_id" {
  value       = aws_vpc.main.id
  description = "Vpc id"
}

output "public_subnets_id" {
  value       = aws_subnet.public.*.id
  description = "Public subnets list id"
}

output "public_subnets_cidr_block" {
  value       = aws_subnet.public.*.cidr_block
  description = "Public subnets list CIDR"
}

output "private_subnets_id" {
  value       = aws_subnet.private.*.id
  description = "Private subnets list id with NAT"
}

output "private_subnets_cidr_block" {
  value       = aws_subnet.private.*.cidr_block
  description = "Private subnets list CIDR with NAT"
}

output "databases_subnets_id" {
  value       = aws_subnet.database.*.id
  description = "Private subnets list id"
}

output "databases_subnets_cidr_block" {
  value       = aws_subnet.database.*.cidr_block
  description = "Private subnets list CIDR"
}
