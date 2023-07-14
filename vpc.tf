locals {
  public_cidr = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  private_cidr = ["10.0.4.0/24","10.0.5.0/24","10.0.6.0/24"]
  availability_zone = ["us-west-1a", "us-west-1c", "us-west-1c"]

  count =2
}

output count {
  value = length(local.public_cidr)
  #value1 = length(local.private_cidr)
}


resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform vpc"
  }

}
resource "aws_subnet" "public" {
  count = length(local.public_cidr)

  vpc_id     = aws_vpc.terraform.id
  cidr_block = local.public_cidr[count.index]
  availability_zone = local.availability_zone[count.index]

  tags = {
    Name = "public${count.index+1}"
  }
}

resource "aws_subnet" "private" {
  count = length(local.private_cidr)

  vpc_id     = aws_vpc.terraform.id
  cidr_block =  local.private_cidr[count.index]
  availability_zone = local.availability_zone[count.index]

  tags = {
    Name = "private${count.index+1}"
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
    Name = "rt-terraform-pub"
  }
}

resource "aws_route_table" "private" {
  count = length(local.private_cidr)
  vpc_id = aws_vpc.terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "rt-terraform-pri"
  }
}

resource "aws_route_table_association" "public" {
  count = length(local.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(local.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}


resource "aws_eip" "eip-terraform" {
  count = length(local.public_cidr)
  vpc      = true

  tags = {
    Name = "eip${count.index+1}"
  }
}

resource "aws_nat_gateway" "nat-pub" {
  count = length(local.public_cidr)
  allocation_id = aws_eip.eip-terraform[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "public-nat-gateway${count.index+1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraform-igw]
}