# Default VPC of your AWS Account.
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name      = "Default VPC"
    Workspace = "${terraform.workspace}"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Default subnets in all required AZs
resource "aws_default_subnet" "default_subnet" {
  count             = "${length(var.availability_zones)}"
  availability_zone = "${var.region}${element(var.availability_zones,count.index)}"

  tags {
    Name      = "Default Subnet for ${var.region}"
    Workspace = "${terraform.workspace}"
  }
}
