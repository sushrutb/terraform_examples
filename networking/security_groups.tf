# Public SG which allows all traffic.
# Dont use in serious applications, for side projects or testing only.
resource "aws_security_group" "allow_all_tls" {
  name        = "allow_all_tls"
  description = "Allow all TLS inbound traffic"
  vpc_id      = "${aws_default_vpc.default_vpc.id}"

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "allow_all_tls"
    Workspace = "${terraform.workspace}"
  }
}

