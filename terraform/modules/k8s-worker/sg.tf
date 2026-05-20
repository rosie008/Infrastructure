resource "aws_security_group" "private_sg" {
  name        = "${var.project_name}-k8s-worker-sg"
  description = "Allow  inbound traffic and all outbound traffic for private instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-k8s-worker-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_private_ipv4" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = var.private_subnet_cidr
  ip_protocol       = "-1" 
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.private_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}