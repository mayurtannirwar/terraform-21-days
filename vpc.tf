resource "aws_vpc" "terraform" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "terraform vpc"
  }

}
resource "aws_subnet" "public1" {
  count = 2

  vpc_id     = aws_vpc.terraform.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "us-west-1a"
  tags = {
    Name = "public${count.index}"
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