provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-06b21ccaeff8cd686" # Amazon Linux 2 AMI ID, mude conforme necessário
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]  # Associar o grupo de segurança

  tags = {
    Name = "WebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              docker run -d -p 80:80 nginx
              EOF
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso de qualquer IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permite todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]
  }
}