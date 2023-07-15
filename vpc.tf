resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform vpc"
  }

}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "public2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-1a"

  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-1c"

  tags = {
    Name = "private2"
  }
}

resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform.id

  tags = {
    Name = "igw-terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "rt-terraform"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "rt-terraform"
  }
}

resource "aws_route_table_association" "rt" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "rt3" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_nat_gateway" "nat-pub" {
  allocation_id = aws_eip.eip-terraform.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "public-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform-igw]
}

resource "aws_eip" "eip-terraform" {
  vpc      = true
}

resource "aws_nat_gateway" "nat-pub1" {
  allocation_id = aws_eip.eip-terraform1.id
  subnet_id     = aws_subnet.public2.id

  tags = {
    Name = "public-nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform-igw]
}

resource "aws_eip" "eip-terraform1" {
  vpc      = true
}