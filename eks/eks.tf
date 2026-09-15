module "vpc" {
  source = "../modules/vpc"

  name                = var.vpc_name
  cidr_block          = var.vpc_cidr_block
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  tags                = var.tags
}

module "eks" {
  source = "../modules/eks-cluster"

  cluster_name                 = var.cluster_name
  cluster_role_name            = var.cluster_role_name
  node_role_name               = var.node_role_name
  node_group_name              = var.node_group_name
  vpc_id                       = module.vpc.vpc_id
  subnet_ids                   = module.vpc.public_subnet_ids
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs
  node_instance_types          = var.node_instance_types
  node_desired_size            = var.node_desired_size
  node_min_size                = var.node_min_size
  node_max_size                = var.node_max_size
  tags                         = var.tags
}

# Route53 permissions for cert-manager DNS01 challenges
resource "aws_iam_policy" "cert_manager_route53" {
  name        = "cert-manager-route53-policy"
  description = "Route53 permissions for cert-manager DNS01 challenges"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "route53:GetChange"
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Effect   = "Allow"
        Action   = "route53:ListHostedZonesByName"
        Resource = "*"
      }
    ]
  })
}

module "cert_manager_irsa" {
  source = "../modules/irsa-role"

  role_name            = "cert-manager-irsa-role"
  oidc_provider_arn    = module.eks.oidc_provider_arn
  oidc_provider_url    = module.eks.oidc_provider_url
  namespace            = var.cert_manager_namespace
  service_account_name = var.cert_manager_service_account
  policy_arns          = [aws_iam_policy.cert_manager_route53.arn]
  tags                 = var.tags
}
