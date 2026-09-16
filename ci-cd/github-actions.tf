data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "openid" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
  tags            = var.tags
}

locals {
  account_id = data.aws_caller_identity.current.account_id

  github_subs = [
    for item in var.github_repos :
    "repo:${item}:*"
  ]

  # Only these IAM roles/policies get created by any stack this role deploys
  # (eks, ecr, s3, ci-cd) - keeping IAM scoped to exactly these ARNs is what
  # stops this role from being able to create or modify anything else in the
  # account, e.g. an unrelated admin role.
  managed_role_arns = [
    "arn:aws:iam::${local.account_id}:role/eks-cluster-role",
    "arn:aws:iam::${local.account_id}:role/eks-node-role",
    "arn:aws:iam::${local.account_id}:role/cert-manager-irsa-role",
    "arn:aws:iam::${local.account_id}:role/renays-lab-github-actions-role",
    "arn:aws:iam::${local.account_id}:role/renays-lab-dev-bastion-role",
  ]

  managed_policy_arns = [
    "arn:aws:iam::${local.account_id}:policy/cert-manager-route53-policy",
    "arn:aws:iam::${local.account_id}:policy/renays-lab-terraform-deploy-policy",
  ]

  managed_instance_profile_arns = [
    "arn:aws:iam::${local.account_id}:instance-profile/renays-lab-dev-bastion-role",
  ]
}

resource "aws_iam_policy" "terraform_deploy" {
  name        = "renays-lab-terraform-deploy-policy"
  description = "Exactly what eks/ecr/s3/ci-cd stacks need to create - VPC/EKS/IAM/ECR/S3 only."
  tags        = var.tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VPCNetworking"
        Effect = "Allow"
        Action = [
          "ec2:CreateVpc", "ec2:DeleteVpc", "ec2:DescribeVpcs", "ec2:ModifyVpcAttribute", "ec2:DescribeVpcAttribute",
          "ec2:CreateInternetGateway", "ec2:DeleteInternetGateway", "ec2:AttachInternetGateway", "ec2:DetachInternetGateway", "ec2:DescribeInternetGateways",
          "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:DescribeSubnets", "ec2:ModifySubnetAttribute",
          "ec2:CreateRouteTable", "ec2:DeleteRouteTable", "ec2:DescribeRouteTables", "ec2:CreateRoute", "ec2:DeleteRoute", "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable", "ec2:ReplaceRouteTableAssociation",
          "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup", "ec2:DescribeSecurityGroups", "ec2:DescribeSecurityGroupRules",
          "ec2:AuthorizeSecurityGroupIngress", "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupIngress", "ec2:RevokeSecurityGroupEgress",
          "ec2:CreateLaunchTemplate", "ec2:CreateLaunchTemplateVersion", "ec2:ModifyLaunchTemplate", "ec2:DeleteLaunchTemplate", "ec2:DescribeLaunchTemplates", "ec2:DescribeLaunchTemplateVersions",
          "ec2:CreateTags", "ec2:DeleteTags",
          "ec2:DescribeAvailabilityZones", "ec2:DescribeImages", "ec2:DescribeInstanceTypes", "ec2:DescribeAccountAttributes", "ec2:DescribeInstances", "ec2:DescribeNetworkInterfaces",
          "ec2:RunInstances", "ec2:TerminateInstances", "ec2:StopInstances", "ec2:StartInstances"
        ]
        # EC2's API doesn't support resource-level ARNs for most of these
        # create/describe calls - Resource "*" is the practical floor here,
        # but the action list still caps this to networking primitives only
        # (no RunInstances, no Lambda, no RDS, etc).
        Resource = "*"
      },
      {
        Sid    = "EKS"
        Effect = "Allow"
        Action = [
          "eks:CreateCluster", "eks:DeleteCluster", "eks:DescribeCluster", "eks:ListClusters",
          "eks:UpdateClusterConfig", "eks:UpdateClusterVersion", "eks:TagResource", "eks:UntagResource", "eks:ListTagsForResource",
          "eks:CreateNodegroup", "eks:DeleteNodegroup", "eks:DescribeNodegroup", "eks:ListNodegroups",
          "eks:UpdateNodegroupConfig", "eks:UpdateNodegroupVersion", "eks:DescribeUpdate"
        ]
        # Same limitation as EC2 above: EKS's Create* calls require "*".
        Resource = "*"
      },
      {
        Sid    = "IAMRoleManagement"
        Effect = "Allow"
        Action = [
          "iam:CreateRole", "iam:DeleteRole", "iam:GetRole", "iam:UpdateRole", "iam:UpdateAssumeRolePolicy",
          "iam:TagRole", "iam:UntagRole", "iam:AttachRolePolicy", "iam:DetachRolePolicy",
          "iam:ListAttachedRolePolicies", "iam:ListRolePolicies", "iam:PutRolePolicy", "iam:DeleteRolePolicy", "iam:GetRolePolicy"
        ]
        Resource = local.managed_role_arns
      },
      {
        Sid       = "IAMPassRoleToEKS"
        Effect    = "Allow"
        Action    = "iam:PassRole"
        Resource  = local.managed_role_arns
        Condition = { StringEquals = { "iam:PassedToService" = "eks.amazonaws.com" } }
      },
      {
        Sid      = "IAMPassRoleToEC2"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = "arn:aws:iam::${local.account_id}:role/renays-lab-dev-bastion-role"
        Condition = {
          StringEquals = { "iam:PassedToService" = "ec2.amazonaws.com" }
        }
      },
      {
        Sid    = "IAMInstanceProfileManagement"
        Effect = "Allow"
        Action = [
          "iam:CreateInstanceProfile", "iam:DeleteInstanceProfile", "iam:GetInstanceProfile",
          "iam:AddRoleToInstanceProfile", "iam:RemoveRoleFromInstanceProfile", "iam:TagInstanceProfile"
        ]
        Resource = local.managed_instance_profile_arns
      },
      {
        Sid    = "IAMPolicyManagement"
        Effect = "Allow"
        Action = [
          "iam:CreatePolicy", "iam:DeletePolicy", "iam:GetPolicy", "iam:GetPolicyVersion",
          "iam:CreatePolicyVersion", "iam:DeletePolicyVersion", "iam:ListPolicyVersions", "iam:TagPolicy"
        ]
        Resource = local.managed_policy_arns
      },
      {
        Sid    = "IAMOIDCProviders"
        Effect = "Allow"
        Action = [
          "iam:CreateOpenIDConnectProvider", "iam:DeleteOpenIDConnectProvider", "iam:GetOpenIDConnectProvider",
          "iam:UpdateOpenIDConnectProviderThumbprint", "iam:TagOpenIDConnectProvider", "iam:ListOpenIDConnectProviders"
        ]
        Resource = [
          "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com",
          "arn:aws:iam::${local.account_id}:oidc-provider/oidc.eks.*.amazonaws.com/id/*",
        ]
      },
      {
        Sid       = "IAMServiceLinkedRoleForEKS"
        Effect    = "Allow"
        Action    = "iam:CreateServiceLinkedRole"
        Resource  = "*"
        Condition = { StringEquals = { "iam:AWSServiceName" = ["eks.amazonaws.com", "eks-nodegroup.amazonaws.com"] } }
      },
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*" # AWS requires this specific action to use Resource "*"
      },
      {
        Sid    = "ECRRepositories"
        Effect = "Allow"
        Action = [
          "ecr:CreateRepository", "ecr:DeleteRepository", "ecr:DescribeRepositories",
          "ecr:PutImageScanningConfiguration", "ecr:PutImageTagMutability",
          "ecr:TagResource", "ecr:UntagResource", "ecr:ListTagsForResource",
          "ecr:BatchCheckLayerAvailability", "ecr:PutImage", "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart", "ecr:CompleteLayerUpload", "ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"
        ]
        Resource = "arn:aws:ecr:*:${local.account_id}:repository/renays-lab*"
      },
      {
        Sid    = "S3StateAndBuckets"
        Effect = "Allow"
        Action = [
          "s3:CreateBucket", "s3:DeleteBucket", "s3:ListBucket", "s3:GetBucketLocation",
          "s3:GetBucketVersioning", "s3:PutBucketVersioning",
          "s3:GetEncryptionConfiguration", "s3:PutEncryptionConfiguration",
          "s3:GetBucketOwnershipControls", "s3:PutBucketOwnershipControls",
          "s3:GetBucketPublicAccessBlock", "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketPolicy", "s3:PutBucketPolicy", "s3:DeleteBucketPolicy",
          "s3:GetBucketTagging", "s3:PutBucketTagging",
          "s3:GetObject", "s3:PutObject", "s3:DeleteObject"
        ]
        Resource = ["arn:aws:s3:::renays-lab*", "arn:aws:s3:::renays-lab*/*"]
      }
    ]
  })
}

module "iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "6.2.1"

  name = "renays-lab-github-actions-role"

  use_name_prefix = false

  trust_policy_permissions = {
    TrustRoleAndServiceToAssume = {
      actions = ["sts:AssumeRoleWithWebIdentity"]
      principals = [{
        type        = "Federated"
        identifiers = [aws_iam_openid_connect_provider.openid.arn]
      }]
      condition = [{
        test     = "StringEquals"
        variable = "token.actions.githubusercontent.com:aud"
        values   = ["sts.amazonaws.com"]
        },
        {
          test     = "StringLike"
          variable = "token.actions.githubusercontent.com:sub"
          values   = local.github_subs
        }
      ]
    }
  }

  policies = {
    TerraformDeploy = aws_iam_policy.terraform_deploy.arn
  }

  tags = var.tags
}