locals {
  public_cidr = ["10.0.1.0/24","10.0.2.0/24"]
  private_cidr = ["10.0.3.0/24","10.0.4.0/24"]
  availability_zone = ["us-west-1a", "us-west-1c"]
}


resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform vpc"
  }

}
resource "aws_subnet" "public" {
  count = 2

  vpc_id     = aws_vpc.terraform.id
  cidr_block = local.public_cidr[count.index]
  availability_zone = local.availability_zone[count.index]
  tags = {
    Name = "public${count.index+1}"
  }
}

resource "aws_subnet" "private" {
  count = 2

  vpc_id     = aws_vpc.terraform.id
  cidr_block =  local.private_cidr[count.index]
  availability_zone = local.availability_zone[count.index]
  tags = {
    Name = "private${count.index+1}"
  }

}

