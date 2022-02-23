locals {
  sg_tags = merge({ "kubernetes.io/cluster/${var.cluster_name}" = "owned" }, var.default_tags)
}

resource "aws_security_group" "eks_cluster_sg" {
  name   = "${var.cluster_name}-sg"
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = "${var.cluster_name}-sg" }, local.sg_tags)
}


resource "aws_security_group_rule" "eks_cluster_https_sg_ingress_rule" {
  security_group_id        = aws_security_group.eks_cluster_sg.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node_group_sg.id

}

resource "aws_security_group_rule" "eks_cluster_public_access_sg_ingress_rule" {
  count             = var.eks_public_access == true ? 1 : 0
  security_group_id = aws_security_group.eks_cluster_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.public_access_cidrs
}

resource "aws_security_group_rule" "eks_cluster_admission_controll_sg_egress_rule" {
  security_group_id        = aws_security_group.eks_cluster_sg.id
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node_group_sg.id #

}
resource "aws_security_group_rule" "eks_cluster_https_access_sg_egress_rule" {
  security_group_id        = aws_security_group.eks_cluster_sg.id
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.node_group_sg.id # private_subnets_cidrs
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



resource "aws_security_group_rule" "node_group_internal_access_sg_ingress_rule" {
  security_group_id = aws_security_group.node_group_sg.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true

}

resource "aws_security_group_rule" "node_group_https_sg_ingress_rule" {
  security_group_id        = aws_security_group.node_group_sg.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

resource "aws_security_group_rule" "node_group_admission_control_sg_ingress_rule" {
  security_group_id        = aws_security_group.node_group_sg.id
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.eks_cluster_sg.id
}

