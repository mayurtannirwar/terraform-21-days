resource "aws_instance" "app_server" {
  ami           = "ami-0f8e81a3da6e2510a"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
    Owner = "first ec2 instance"
  }
}