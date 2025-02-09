resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.commn_tags,
    var.vpc_tags,
    {
      Name = local.resource_name
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.commn_tags,
    var.igw_tags,
    {
      Name = local.resource_name
    }
  )
}

# kdp-expense-prod-public-us-east-1a & 1b
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.commn_tags,
    var.public_subet_tags,
    {
      Name = "${local.resource_name}-public-${local.az_names[count.index]}"
    }
  )
}

# kdp-expense-prod-private-us-east-1a & 1b
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.commn_tags,
    var.private_subnet_tags,
    {
      Name = "${local.resource_name}-private-${local.az_names[count.index]}"
    }
  )
}

# kdp-expense-prod-database-us-east-1a & 1b
resource "aws_subnet" "database" {
  count             = length(var.database_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    var.commn_tags,
    var.database_subnet_tags,
    {
      Name = "${local.resource_name}-database-${local.az_names[count.index]}"
    }
  )

}

resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.eip.id

  tags = merge(
    var.commn_tags,
    var.nat_gateway_tags,
    {
      Name = "${local.resource_name}-NAT"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.commn_tags,
    var.public_route_table_tags,
    {
      Name = "${local.resource_name}-public"
    }
  )

}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.commn_tags,
    var.private_route_table_tags,
    {
      Name = "${local.resource_name}-private"
    }
  )

}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.commn_tags,
    var.database_route_table_tags,
    {
      Name = "${local.resource_name}-database"
    }
  )

}

resource "aws_route" "rpub" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "rpri" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "rdata" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "associationpub" {
  count          = length(var.public_subnet_cidr)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id

}

resource "aws_route_table_association" "associationprivate" {
  count          = length(var.private_subnet_cidr)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id

}

resource "aws_route_table_association" "associationdata" {
  count          = length(var.database_subnet_cidr)
  route_table_id = aws_route_table.database.id
  subnet_id      = aws_subnet.database[count.index].id

}