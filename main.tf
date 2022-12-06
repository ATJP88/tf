resource "aws_vpc" "tf_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf1"
  }
}

resource "aws_subnet" "tf_subnet" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf1"
  }
}

resource "aws_network_interface" "tf_network" {
  subnet_id   = aws_subnet.tf_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "tf1"
  }
}

resource "aws_instance" "tf-instance" {
  ami           = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.tf_network.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  } 
  tags = {
    Name = "tf1"
  }
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.tf_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
