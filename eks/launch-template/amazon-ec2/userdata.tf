locals {
  default_node_labels = { "eks.amazonaws.com/nodegroup-image" = data.aws_ssm_parameter.ami_id.value,
    "eks.amazonaws.com/capacityType" = "ON_DEMAND",
  "eks.amazonaws.com/nodegroup" = var.ng_name }

  node_lables = format("--node-labels=%s",
    join(",", [for k, v in merge(var.node_lables, local.default_node_labels) :
  "${k}=${v}"]))


  node_taints = length(var.node_taints) >= 1 ? format(" --register-with-taints=%s",
    join(",",
      [for e in var.node_taints :
  "${e.name}=${e.value}:${e.type}"])) : ""

  extra_args = length(var.kubelet_extra_args) >= 1 ? join(",", [for k, v in var.kubelet_extra_args :
  "${k}=${v}"]) : ""

  kubelet_extra_args = format("--kubelet-extra-args '%s %s %s'", local.node_lables, local.node_taints, local.extra_args)

  dns_service_ip = cidrhost(data.aws_eks_cluster.eks_cluster.kubernetes_network_config[0].service_ipv4_cidr, 10)
  user_data_vars = { cluster-endpoint = data.aws_eks_cluster.eks_cluster.endpoint,
    cluster-ca           = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data,
    cluster-name         = var.cluster_name
    "kubelet_extra_args" = local.kubelet_extra_args
    "dns_service_ip"     = local.dns_service_ip
  }
}