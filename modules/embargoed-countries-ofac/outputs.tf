output "group_rule_name" {
  description = "Name of created group rule"
  value       = aws_wafv2_rule_group.embargoed_territories.name
}

output "group_rule_id" {
  description = "ID of created group rule"
  value       = aws_wafv2_rule_group.embargoed_territories.id
}

output "group_rule_arn" {
  description = "ARN of created group rule"
  value       = aws_wafv2_rule_group.embargoed_territories.arn
}
