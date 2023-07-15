resource "aws_instance" "complex" {
  ami                         = "ami-0f8e81a3da6e2510a"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "new-world"
  vpc_security_group_ids      = [aws_security_group.terraform-complex.id]
  subnet_id                   = aws_subnet.public[0].id

  tags = {
    Name = "public"
  }

}

resource "aws_security_group" "terraform-complex" {
  name        = "public"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["106.213.85.33/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public"
  }

}


resource "aws_instance" "private-complex" {
  ami                         = "ami-0f8e81a3da6e2510a"
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  key_name                    = "new-world"
  vpc_security_group_ids      = [aws_security_group.private-sg.id]
  subnet_id                   = aws_subnet.private[0].id

  tags = {
    Name = "private"
  }

}

resource "aws_security_group" "private-sg" {
  name        = "private"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.terraform.id

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.private_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private"
  }

}