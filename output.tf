output "vpc-info" {
  value = aws_vpc.main.id
}

output "az_info" {
  value = data.aws_availability_zones.available
}

output "eip" {
  value = aws_eip.eip.id
}

output "rpub" {
  value = aws_route_table.public.id
}

output "igw" {
  value = aws_internet_gateway.igw.id
}

output "default_vpc_info" {
  value = data.aws_vpc.default.cidr_block

}

output "peering_info" {
  value = aws_vpc_peering_connection.peering[0].id # we can provide this one also [count.index]
}