locals {
  sg_tags = merge({ "kubernetes.io/cluster/${var.cluster_name}" = "owned" }, var.default_tags)
}

resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-sg"
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = "${var.cluster_name}-sg" }, local.sg_tags)
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_https_sg_ingress_rule" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.node_group_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "eks_cluster_public_access_sg_ingress_rule" {
  for_each          = toset(var.eks_public_access == true ? var.public_access_cidrs : [])
  security_group_id = aws_security_group.eks_cluster_sg.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = each.value

}

resource "aws_vpc_security_group_egress_rule" "eks_cluster_admission_controll_sg_egress_rule" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  cidr_ipv4                    = "10.0.0.0/8"
  ip_protocol                  = "tcp"
  from_port                    = 1025
  to_port                      = 65535
  referenced_security_group_id = aws_security_group.node_group_sg.id
}

resource "aws_vpc_security_group_egress_rule" "eks_cluster_https_access_sg_egress_rule" {
  security_group_id            = aws_security_group.eks_cluster_sg.id
  cidr_ipv4                    = "10.0.0.0/8"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.node_group_sg.id
}


resource "aws_security_group" "node_group_sg" {
  name   = "${var.cluster_name}-node-group-sg"
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = "${var.cluster_name}-node-group-sg" }, local.sg_tags)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_vpc_security_group_ingress_rule" "node_group_internal_access_sg_ingress_rule" {
  security_group_id            = aws_security_group.node_group_sg.id
  from_port                    = 0
  to_port                      = 0
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.node_group_sg.id
}

resource "aws_vpc_security_group_ingress_rule" "node_group_https_sg_ingress_rule" {
  security_group_id            = aws_security_group.node_group_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "TCP"
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
}


resource "aws_vpc_security_group_ingress_rule" "node_group_admission_control_sg_ingress_rule" {
  security_group_id            = aws_security_group.node_group_sg.id
  from_port                    = 1025
  to_port                      = 65535
  ip_protocol                  = "TCP"
  referenced_security_group_id = aws_security_group.eks_cluster_sg.id
}
