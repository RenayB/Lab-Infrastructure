# Latest Amazon Linux 2023 arm64 AMI - matches the Graviton (t4g) instance
# family for the best price/performance on a box that just idles most of the
# time running the SSM agent.
data "aws_ami" "al2023_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

resource "aws_iam_role" "bastion" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

# This is the entire point of the role: lets SSM Session Manager connect to
# the instance with no inbound ports, no SSH keys, and access controlled by
# IAM (ssm:StartSession) rather than by source IP.
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "bastion" {
  name = var.role_name
  role = aws_iam_role.bastion.name

  tags = var.tags
}

# No inbound rules at all - SSM's connection is outbound-only from the
# instance to AWS's SSM service, so there's nothing to open for it.
resource "aws_security_group" "bastion" {
  name_prefix = "${var.role_name}-"
  description = "SSM bastion - outbound only, no inbound rules"
  vpc_id      = data.terraform_remote_state.eks.outputs.vpc_id

  egress {
    description = "All outbound (SSM agent, package updates, reaching the EKS API)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.role_name}-sg" })

  lifecycle {
    create_before_destroy = true
  }
}

# The cluster's AWS-managed security group only allows traffic from itself
# and the node security group by default - without this, the bastion can't
# reach the private API endpoint at all despite being in the same VPC.
resource "aws_security_group_rule" "cluster_from_bastion" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = data.terraform_remote_state.eks.outputs.cluster_security_group_id
  source_security_group_id = aws_security_group.bastion.id
  description              = "Bastion access to the private EKS API endpoint"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023_arm.id
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.eks.outputs.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion.name
  associate_public_ip_address = true

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 8
    encrypted   = true
  }

  tags = merge(var.tags, { Name = var.role_name })
}
