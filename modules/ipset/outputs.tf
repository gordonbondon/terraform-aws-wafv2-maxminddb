output "name" {
  description = "Name of created IP Set"
  value       = aws_wafv2_ip_set.geo.name
}

output "id" {
  description = "ID of created IP Set"
  value       = aws_wafv2_ip_set.geo.id
}


output "arn" {
  description = "ARN of created IP Set"
  value       = aws_wafv2_ip_set.geo.arn
}
