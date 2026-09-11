# These resources moved into terraform/modules/{vpc,eks-cluster,irsa-role}
# when this stack was made deployable to any AWS account. The blocks below
# keep pre-existing state pointed at the same real resources instead of
# destroying and recreating them.

moved {
  from = aws_vpc.eks_vpc
  to   = module.vpc.aws_vpc.this
}

moved {
  from = aws_internet_gateway.internet_gateway
  to   = module.vpc.aws_internet_gateway.this
}

moved {
  from = aws_subnet.public_a
  to   = module.vpc.aws_subnet.public[0]
}

moved {
  from = aws_subnet.public_b
  to   = module.vpc.aws_subnet.public[1]
}

moved {
  from = aws_route_table.public
  to   = module.vpc.aws_route_table.public
}

moved {
  from = aws_route_table_association.public_a
  to   = module.vpc.aws_route_table_association.public[0]
}

moved {
  from = aws_route_table_association.public_b
  to   = module.vpc.aws_route_table_association.public[1]
}

moved {
  from = aws_iam_role.eks_cluster
  to   = module.eks.aws_iam_role.eks_cluster
}

moved {
  from = aws_iam_role_policy_attachment.cluster_policy
  to   = module.eks.aws_iam_role_policy_attachment.cluster_policy
}

moved {
  from = aws_eks_cluster.cluster
  to   = module.eks.aws_eks_cluster.this
}

moved {
  from = aws_iam_openid_connect_provider.renays_lab_oidc
  to   = module.eks.aws_iam_openid_connect_provider.this
}

moved {
  from = aws_iam_role.eks_node_role
  to   = module.eks.aws_iam_role.eks_node
}

moved {
  from = aws_iam_role_policy_attachment.node_group_policy
  to   = module.eks.aws_iam_role_policy_attachment.node_group_policy
}

moved {
  from = aws_eks_node_group.eks_node_group
  to   = module.eks.aws_eks_node_group.this
}

moved {
  from = aws_iam_role.cert_manager_irsa
  to   = module.cert_manager_irsa.aws_iam_role.this
}

moved {
  from = aws_iam_role_policy_attachment.cert_manager
  to   = module.cert_manager_irsa.aws_iam_role_policy_attachment.this[0]
}
