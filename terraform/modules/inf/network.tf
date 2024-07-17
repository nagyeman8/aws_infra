# resource "aws_default_vpc" "default" {
#   tags = {
#     Name = "Default VPC" # Replace with the name of your VPC
#   }
# }

resource "aws_vpc" "vpc" {
  instance_tenancy     = "default"
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-vpc" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_internet_gateway" "vpc_internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-vpc-int-gwy" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat_eip.id # Replace with your NAT EIP id
  subnet_id     = aws_subnet.public-subnet1.id
  depends_on    = [aws_internet_gateway.vpc_internet_gateway]

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-ngw" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-nat-eip" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }

}