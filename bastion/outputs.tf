output "instance_id" {
  value       = aws_instance.bastion.id
  description = "Use with: aws ssm start-session --target <instance_id>, or as the --target for port forwarding to the EKS API."
}

output "role_arn" {
  value = aws_iam_role.bastion.arn
}
