module "rule_group" {
  source = "../../modules/embargoed-countries-ofac"

  scope = "CLOUDFRONT"
}

resource "aws_wafv2_web_acl" "block" {
  name        = "block"
  description = "Block embargoed countries"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    name     = "country-block"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        # reference group rule in new WEB acl config
        arn = module.rule_group.group_rule_arn
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

resource "aws_s3_bucket" "b" {
  bucket = "mybucket"
  acl    = "private"

  tags = {
    Name = "My bucket"
  }
}

locals {
  s3_origin_id = "myS3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  # use new ACL on your distribution
  web_acl_id = aws_wafv2_web_acl.block.arn

  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
