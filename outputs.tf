output "vpc_id" {
  value = aws_vpc.network.id
}

output "public_subnets_id" {
  value = [ for s in aws_subnet.public-subnets : s.id ]
}

output "private_subnets_id" {
    value = [ for s in aws_subnet.private-subnets : s.id ]
}


output "igw_id" {
  value = aws_internet_gateway.network-igw.id
}
output "nat_id" {
  value = aws_nat_gateway.network-nat.id
}
