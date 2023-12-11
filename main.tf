# network VPC --------------------------------------------------
resource "aws_vpc" "network" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpc_name
  }
}

# Subnets -----------------------------------------------------
resource "aws_subnet" "public-subnets" {
  count = length(var.AZ)
  vpc_id                  = aws_vpc.network.id
  cidr_block              = cidrsubnet(var.cidr, var.subnet_mask, count.index)
  availability_zone       = var.AZ[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}
resource "aws_subnet" "private-subnets" {
  count = length(var.AZ)
  vpc_id                  = aws_vpc.network.id
  cidr_block              = cidrsubnet(var.cidr, var.subnet_mask, length(var.AZ)+count.index)
  availability_zone       = var.AZ[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index}"
  }
}
# Internet Gateway --------------------------------------------
resource "aws_internet_gateway" "network-igw" {
  vpc_id = aws_vpc.network.id

  tags = {
    Name = "network-IGW"
  }
}

# Elastic IP --------------------------------------------------
resource "aws_eip" "network-eip" {
  domain = "vpc"

  tags = {
    Name = "network-EIP"
  }
}

# NAT Gateway -------------------------------------------------
resource "aws_nat_gateway" "network-nat" {
  allocation_id = aws_eip.network-eip.id
  subnet_id     = aws_subnet.public-subnets[0].id

  tags = {
    Name = "network-NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.network-igw]
}

# Route tables --------------------------------------------------
resource "aws_default_route_table" "public-rt" {
  default_route_table_id = aws_vpc.network.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.network-igw.id
  }

  tags = {
    Name = "public-RT"
  }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.network.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.network-nat.id
  }

  tags = {
    Name = "private-RT"
  }
}

# Associate Route tables
resource "aws_route_table_association" "public-associate" {
  count = length(var.AZ)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_default_route_table.public-rt.id
}

resource "aws_route_table_association" "private-associate" {
  count = length(var.AZ)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.private-rt.id
}
