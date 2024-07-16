output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs-cluster.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs-cluster.name
}

output "rds_subnet1_id" {
  value = aws_subnet.rds-subnet1.id
}

output "rds_subnet2_id" {
  value = aws_subnet.rds-subnet2.id
}

output "public_subnet1_id" {
  value = aws_subnet.public-subnet1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public-subnet2.id
}

output "private_subnet1_id" {
  value = aws_subnet.private-subnet1.id
}

output "private_subnet2_id" {
  value = aws_subnet.private-subnet2.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "rds_subnet_group_id" {
  value = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "react_subnet1_id" {
  value = aws_subnet.react_subnet1.id
}

output "node_subnet1_id" {
  value = aws_subnet.node_subnet1.id
}

output "python_subnet1_id" {
  value = aws_subnet.python_subnet1.id
}

output "react_subnet2_id" {
  value = aws_subnet.react_subnet2.id
}

output "node_subnet2_id" {
  value = aws_subnet.node_subnet2.id
}

output "python_subnet2_id" {
  value = aws_subnet.python_subnet2.id
}

output "react_sg_id" {
  value = aws_security_group.react_sg.id
}

output "node_sg_id" {
  value = aws_security_group.node_sg.id
}

output "python_sg_id" {
  value = aws_security_group.python_sg.id
}

output "assets_cdn_s3_id" {
  value = aws_s3_bucket.assets_cdn_s3.id
}

output "assets_cdn_s3_rdn" {
  value = aws_s3_bucket.assets_cdn_s3.bucket_regional_domain_name
}

output "rds_db_identifier" {
  value = aws_db_instance.database.identifier
}