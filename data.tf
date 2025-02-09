data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true # to get deafult vpc id
}

data "aws_route_table" "main" {
  vpc_id = local.default_vpc_id
  filter {
    name = "association.main"
    values = ["true"]
  }
}