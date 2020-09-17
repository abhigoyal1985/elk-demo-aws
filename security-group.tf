resource "aws_security_group" "allow" {
  name        = "Elastic_Search_FW"
  description = "Allow user ips"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = "5601"
    to_port     = "5601"
    protocol    = "tcp"
    cidr_blocks = ["183.87.50.134/32"]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["183.87.50.134/32"]
  }
  
  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "9200"
    to_port     = "9200"
    protocol    = "tcp"
    cidr_blocks = ["183.87.50.134/32","172.31.0.0/16"]
  }
  
  ingress {
  
    from_port   = "9300"
    to_port     = "9300"
    protocol    = "tcp"
    cidr_blocks = ["183.87.50.134/32","172.31.0.0/16"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow restricted access"
  }
}
