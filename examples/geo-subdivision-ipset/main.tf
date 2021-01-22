module "geo_ipset" {
  source = "../../modules/ipset"

  name  = "eng-gb-ipv4-net"
  scope = "CLOUDFRONT"

  ip_address_version = "IPV4"
  countries = {
    "GB" = ["ENG"]
  }
}

resource "aws_wafv2_web_acl" "geo_rate_limit" {
  name        = "managed-rule-example"
  description = "Rate limit only ENG IPV4 region from GB."
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name = "eng-gb-ipv4-net-rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          ip_set_reference_statement {
            arn = module.geo_ipset.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}
