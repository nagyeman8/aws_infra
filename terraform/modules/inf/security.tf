resource "aws_security_group" "ecs_sg" {
  name                   = join("-", [local.name_prefix, "ecs-sg"])
  description            = "${local.name_prefix} ecs security group"
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-ecs-sg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_security_group" "alb_sg" {
  name                   = join("-", [local.name_prefix, "alb-sg"])
  description            = "${local.name_prefix} alb security group"
  vpc_id                 = aws_vpc.vpc.id
  revoke_rules_on_delete = true

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-alb-sg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_security_group_rule" "ecs_alb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow inbound traffic from ALB"
  security_group_id        = aws_security_group.ecs_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}


resource "aws_security_group_rule" "ecs_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from ECS"
  security_group_id = aws_security_group.ecs_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "alb_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  description       = "Allow http inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "alb_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  description       = "Allow https inbound traffic from internet"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow outbound traffic from alb"
  security_group_id = aws_security_group.alb_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group" "rds_sg" {
  name        = join("-", [local.name_prefix, "rds-sg"])
  description = "${local.name_prefix} security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  # ingress {
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   cidr_blocks = [var.vpn_ip]
  # }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-rds-sg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_security_group" "react_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-react-sg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_security_group" "node_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-node-sg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_security_group" "python_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.default_tags, var.inf_override_tags, { Name = "${var.project_name}-${var.env_name}-python-sg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}
