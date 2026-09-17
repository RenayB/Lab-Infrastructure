output "zone_id" {
  value = aws_route53_zone.this.zone_id
}

output "name_servers" {
  value       = aws_route53_zone.this.name_servers
  description = "Add these as an NS record set for the same domain_name in the ROOT account's renays-lab.com hosted zone to delegate this subdomain to this zone."
}
