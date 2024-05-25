output "vpc_id" {
  value = aws_vpc.slipchuk.id
}

output "vpc_name" {
  value = aws_vpc.slipchuk.tags.Name
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.slipchuk-igw.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.slipchuk-nat[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = length(var.private_subnet_cidrs) > 0 ? aws_route_table.private[0].id : ""
}