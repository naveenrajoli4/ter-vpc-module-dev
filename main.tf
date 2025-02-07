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
resource "aws_subnet" "main" {
    count = length(var.public_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.commn_tags,
        var.public_subet_tags,
        {
            Name = "${local.resource_name}-public-${local.az_names[count.index]}"
        }
    )
}

# kdp-expense-prod-private-us-east-1a & 1b
resource "aws_subnet" "mainprivate"{
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]
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
resource "aws_subnet" "maindatabase" {
    count = length(var.database_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.commn_tags,
        var.database_subnet_tags,
        {
            Name = "${local.resource_name}-database-${local.az_names[count.index]}"
        }
    )

}