# VPC Config
resource "aws_vpc" "rupa_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "rupa_vpc"
  }
}

resource "aws_internet_gateway" "rupa_ig" {
  vpc_id = aws_vpc.rupa_vpc.id

  tags = {
    Name = "rupa_ig"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.rupa_vpc.id

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.rupa_ng.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.rupa_vpc.id

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.rupa_ig.id
}

# Subnet config
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.rupa_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-1b"

  tags = {
    Name = "PrivateSubnet"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.rupa_vpc.id
  cidr_block        = "10.1.3.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "PrivateSubnet2"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.rupa_vpc.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.rupa_vpc.id
  cidr_block              = "10.1.4.0/24"
  availability_zone       = "us-west-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# NAT resources
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "rupa_ng" {
  depends_on = [aws_internet_gateway.rupa_ig]

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "rupa_ng"
  }
}

# Security Groups
resource "aws_security_group" "rupa_simple_app_sg" {
  name        = "rupa_simple_app_sg"
  description = "Rupa App Security Group"
  vpc_id      = aws_vpc.rupa_vpc.id

  ingress {
    protocol         = "tcp"
    from_port        = 8080
    to_port          = 8080
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
