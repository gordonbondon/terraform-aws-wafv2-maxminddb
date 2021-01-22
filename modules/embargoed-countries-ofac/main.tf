module "ipset_subdivisions" {
  source = "../ipset"

  for_each = toset(["IPV4", "IPV6"])

  name  = "${var.name_prefix}-subdivisions-${each.key}"
  scope = var.scope

  ip_address_version = each.key
  countries          = var.embargoed_subdivisions

  tags = var.tags
}

resource "aws_wafv2_ip_set" "ipset_ips" {
  for_each = var.embargoed_ips

  name  = "${var.name_prefix}-ips-${each.key}"
  scope = var.scope

  ip_address_version = each.key
  addresses          = each.value

  tags = var.tags
}

resource "aws_wafv2_rule_group" "embargoed_territories" {
  name        = "${var.name_prefix}-rule-group"
  description = "Rule group to block embargoed territories"

  scope = var.scope

  # https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-statements-list.html
  capacity = 10

  rule {
    name     = var.name_prefix
    priority = var.priority

    action {
      block {}
    }

    statement {
      or_statement {
        dynamic "statement" {
          for_each = concat(
            values(module.ipset_subdivisions)[*].arn,
            values(aws_wafv2_ip_set.ipset_ips)[*].arn
          )

          content {
            ip_set_reference_statement {
              arn = statement.value
            }
          }
        }

        statement {
          geo_match_statement {
            country_codes = var.embargoed_countries
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.visibility_config.cloudwatch_metrics_enabled
      metric_name                = "${var.visibility_config.metric_name}-rule"
      sampled_requests_enabled   = var.visibility_config.sampled_requests_enabled
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.visibility_config.cloudwatch_metrics_enabled
    metric_name                = var.visibility_config.metric_name
    sampled_requests_enabled   = var.visibility_config.sampled_requests_enabled
  }

  tags = var.tags
}
