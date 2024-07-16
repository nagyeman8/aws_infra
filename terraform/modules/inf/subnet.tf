# Creates RDS SUBNETS
resource "aws_subnet" "rds-subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2)
  availability_zone = "${var.region}a"
  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-rds-subnet1" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_subnet" "rds-subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 3)
  availability_zone = "${var.region}b"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-rds-subnet2" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# Creates PUBLIC SUBNETS
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 4)
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-public-subnet1" }
  )

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, 5)
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-public-subnet2" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# Creates PRIVATE SUBNETS
resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 6)
  availability_zone = "${var.region}a"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-private-subnet1" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 7)
  availability_zone = "${var.region}a"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-private-subnet2" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# Creates REACT SUBNETS
resource "aws_subnet" "react_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 8)
  availability_zone = "${var.region}a"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-react-subnet1" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_subnet" "react_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 11)
  availability_zone = "${var.region}b"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-react-subnet2" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# Creates PYTHON SUBNETS
resource "aws_subnet" "python_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 10)
  availability_zone = "${var.region}a"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-python-subnet1" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_subnet" "python_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 13)
  availability_zone = "${var.region}b"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-python-subnet2" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



#Creates NODE SUBNETS
resource "aws_subnet" "node_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 9)
  availability_zone = "${var.region}a"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-node-subnet1" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_subnet" "node_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 12)
  availability_zone = "${var.region}b"

  tags = merge(
    local.default_tags,
    var.inf_override_tags,
    { Name = "${var.project_name}-${var.env_name}-node-subnet2" }
  )
  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# Creates RDS SUBNET GROUP
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = join("-", [local.name_prefix, "rds", "subnetgrp"])
  subnet_ids = [aws_subnet.rds-subnet1.id, aws_subnet.rds-subnet2.id]

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-rds-subnet-group" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}



# Creates PUBLIC ROUTE TABLE & ROUTES
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-public-rtl" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_internet_gateway.id
}


resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "react_subnet1" {
  subnet_id      = aws_subnet.react_subnet1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "react_subnet2" {
  subnet_id      = aws_subnet.react_subnet2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "node_subnet1" {
  subnet_id      = aws_subnet.node_subnet1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "node_subnet2" {
  subnet_id      = aws_subnet.node_subnet2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "python_subnet1" {
  subnet_id      = aws_subnet.python_subnet1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "python_subnet2" {
  subnet_id      = aws_subnet.python_subnet2.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "rds-subnet1" {
  subnet_id      = aws_subnet.rds-subnet1.id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "rds-subnet2" {
  subnet_id      = aws_subnet.rds-subnet2.id
  route_table_id = aws_route_table.public.id
}



# Creates PRIVATE ROUTE TABLE AND ROUTES
resource "aws_route_table" "private-rtl" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-private-rtl" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.private-rtl.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}


resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-rtl.id
}


resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-rtl.id
}