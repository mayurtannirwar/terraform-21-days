resource "aws_instance" "complex" {
  ami                         = "ami-0f8e81a3da6e2510a"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "new-world"
  vpc_security_group_ids      = []
  subnet_id                   = [aws_subnet.public[0].id]

  tags = {
    Name = "${var.env_code}-public"
  }

}

resource "aws_security_group" "terra-complex" {
  name        = "${var.env_code}-public"
  description = "Allow inbound traffic"
  vpc         = aws_vpc.terraform.vpc_id

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["106.213.85.33"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-public"
  }

}