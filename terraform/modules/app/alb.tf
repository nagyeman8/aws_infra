resource "aws_lb" "react_alb" {
  name               = join("-", [local.name_prefix, "react-alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.react_sg_id]
  subnets            = [var.react_subnet1_id, var.react_subnet2_id]

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-react-alb" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_lb_listener" "react_http" {
  load_balancer_arn = aws_lb.react_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener" "react_https" {
  load_balancer_arn = aws_lb.react_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.react_cert.arn

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.react_tg.arn
  }
}


resource "aws_lb_target_group" "react_tg" {
  name        = join("-", [local.name_prefix, "react-tg"])
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = 300
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # duration in seconds (1 day)
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-react-tg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_lb" "node_alb" {
  name               = join("-", [local.name_prefix, "node-alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.node_sg_id]
  subnets            = [var.node_subnet1_id, var.node_subnet2_id]

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-node-alb" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }

}


resource "aws_lb_listener" "node_https" {
  load_balancer_arn = aws_lb.node_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.node_cert.arn

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.node_tg.arn
  }
}


resource "aws_lb_target_group" "node_tg" {
  name        = join("-", [local.name_prefix, "node-tg"])
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/v1/health"
    interval            = 300
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # duration in seconds (1 day)
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-node-tg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_lb" "python_alb" {
  name               = join("-", [local.name_prefix, "python-alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.python_sg_id]
  subnets            = [var.python_subnet1_id, var.python_subnet2_id]

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-python-alb" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }
}


resource "aws_lb_listener" "python_https" {
  load_balancer_arn = aws_lb.python_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.python_cert.arn

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.python_tg.arn
  }
}


resource "aws_lb_target_group" "python_tg" {
  name        = join("-", [local.name_prefix, "python-tg"])
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/health"
    interval            = 300
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400 # duration in seconds (1 day)
  }

  tags = merge(local.default_tags, var.app_override_tags, { Name = "${var.project_name}-${var.env_name}-python-tg" })

  lifecycle {
    ignore_changes = [
      tags["CreatedOnDate"]
    ]
  }

}


resource "aws_lb_target_group" "node_to_python_tg" {
  name     = "node-to-python-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health" # Update with your health check path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}