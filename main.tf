provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-06b21ccaeff8cd686" # Amazon Linux 2 AMI ID, mude conforme necessário
  instance_type = "t2.micro"

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