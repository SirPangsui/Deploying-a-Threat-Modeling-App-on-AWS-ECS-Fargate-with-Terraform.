# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.project_name}-vpc"
    Project     = var.project_name
    Environment = "production"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnets" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true  # Enable public IP assignment for instances
  availability_zone = element(["${var.region}a","${var.region}b"], count.index)

  tags = {
    Name    = "${var.project_name}-public-subnet-${count.index + 1}"
    Project = var.project_name
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnets" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(["${var.region}a","${var.region}b"], count.index)

  tags = {
    Name    = "${var.project_name}-private-subnet-${count.index + 1}"
    Project = var.project_name
  }
}

# Create an Internet Gateway for public access
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-internet-gateway"
    Project = var.project_name
  }
}

# Create a NAT Gateway for private subnets
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id  # Use Elastic IP for NAT Gateway
  subnet_id     = aws_subnet.public_subnets[0].id  # Attach to a public subnet
  tags = {
    Name    = "${var.project_name}-nat-gateway"
    Project = var.project_name
  }
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"  # Allocate Elastic IP in the VPC
  tags = {
    Name    = "${var.project_name}-nat-eip"
    Project = var.project_name
  }
}

# Create Route Tables for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-public-route-table"
    Project = var.project_name
  }
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public_association" {
  count = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create Route to allow outbound internet traffic from Public Subnets
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"  # Default route to the internet
  gateway_id             = aws_internet_gateway.main.id
}

# Create Route Tables for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name    = "${var.project_name}-private-route-table"
    Project = var.project_name
  }
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private_association" {
  count = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}

# Create Route to allow private subnets to access the internet via NAT Gateway
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"  # Default route to the internet via NAT
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Outputs for debugging and verification
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}
