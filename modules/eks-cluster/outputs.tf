output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.this.url
}

output "node_security_group_id" {
  value       = aws_security_group.node.id
  description = "Security group attached to worker nodes. When you add a load balancer/ingress for the site, allow inbound to this group from the LB's security group rather than opening it to 0.0.0.0/0."
}

output "cluster_security_group_id" {
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description = "AWS-managed security group for the cluster's ENIs. Anything reaching the private API endpoint (e.g. the bastion) needs an inbound rule here on 443."
}
