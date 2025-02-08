output "vpc-info" {
    value = aws_vpc.main.id
}

output "az_info" {
    value = data.aws_availability_zones.available
}

output "eip" {
    value = aws_eip.eip.id
}
