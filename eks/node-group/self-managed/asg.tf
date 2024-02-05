locals {
  asg_tags = { "eks:cluster-name" = var.cluster_name,
    "eks:nodegroup-name"                            = var.ng_name,
    "k8s.io/cluster-autoscaler/enabled"             = "true",
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned",
  "kubernetes.io/cluster/${var.cluster_name}" = "owned" }
}

resource "aws_autoscaling_group" "node_group_asg" {
  name                = "${var.cluster_name}-${var.ng_name}-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = data.aws_eks_cluster.eks_cluster.vpc_config[0].subnet_ids
  capacity_rebalance  = false
  default_cooldown    = 60
  launch_template {
    name    = var.launch_template_name
    version = "$Latest"
  }
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.initial_size
  termination_policies      = ["OldestLaunchTemplate", "OldestInstance"]
  suspended_processes       = []
  instance_refresh {
    strategy = "Rolling"
    preferences {
      checkpoint_delay = 300
      instance_warmup  = 300
    }

  }

  dynamic "tag" {
    for_each = merge(local.asg_tags, var.default_tags)
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }

  }
}


