locals {
  default_node_labels = {"eks.amazonaws.com/nodegroup-name" = var.ng_name,
                         "eks.amazonaws.com/capacityType" = "ON_DEMAND",
                         "eks.amazonaws.com/nodegroup-image" = var.ami_id,
                         "eks.amazonaws.com/cluster-name" = var.cluster_name,
                         "eks.amazonaws.com/sourceLaunchTemplateId" = "${var.cluster_name}-${var.ng_name}-template"}
  

  node_labels = merge(var.additional_node_labels,local.default_node_labels)

  



  default_extra_settings  =  {"max-pods" = var.max_pods}

  extra_settings = merge(var.extra_settings , local.default_extra_settings)



  dns_service_ip = cidrhost(data.aws_eks_cluster.eks_cluster.kubernetes_network_config[0].service_ipv4_cidr, 10)

  user_data_vars = { cluster_endpoint =     data.aws_eks_cluster.eks_cluster.endpoint,
    cluster_ca          = data.aws_eks_cluster.eks_cluster.certificate_authority[0].data,
    cluster_name        = var.cluster_name,
    dns_cluster_ip     = local.dns_service_ip,
    node_labels        = local.node_labels,
    node_taints        = var.node_taints,
    extra_settings     = local.extra_settings,
    enable_ssh_access = true
  }
}